import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia_admin/core/utils/errors/firebase_failures.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';

/// Enhanced FirestoreService with improved error handling, performance, and maintainability
/// Features:
/// - Automatic totalDebitMoney calculation (sum of all recordMoneyValue)
/// - Time-based sorting for debit items (newest first by default)
/// - Robust error handling and validation
/// - Transaction-based consistency
class FirestoreService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constants for better maintainability
  static const String _usersCollection = 'users';
  static const String _debitItemsCollection = 'debitItems';
  static const String _ownedItemsCollection = 'ownedItems';
  static const String _uniqueNameField = 'uniqueName';
  static const String _phoneNumberField = 'phoneNumber';
  static const String _statusField = 'status';
  static const String _createdAtField = 'createdAt';
  static const String _recordMoneyValueField = 'recordMoneyValue';
  static const String _totalDebitMoneyField = 'totalDebitMoney';
  static const String _totalMoneyOwedField = 'totalMoneyOwed';

  // Owed status constants
  static const Set<String> _owedStatuses = {'pending', 'unpaid', 'overdue'};

  // Collection references with better naming

  // users collection
  CollectionReference get _usersRef => _firestore.collection(_usersCollection);

  // debits collection
  CollectionReference _debitItemsRef(String userId) =>
      _usersRef.doc(userId).collection(_debitItemsCollection);

  // owned collections
  CollectionReference _ownedItemsRef(String userId) =>
      _usersRef.doc(userId).collection(_ownedItemsCollection);

  ///  ******************************************************************************************

  // ============ USER FUNCTIONS ============

  /// Create a new user with improved error handling and validation
  Future<String> createUser({
    required String uniqueName,
    required String phoneNumber,
  }) async {
    try {
      // Input validation
      _validateUserInput(uniqueName, phoneNumber);

      // Check uniqueness more efficiently
      if (await _isUniqueNameTaken(uniqueName)) {
        throw FirebaseFailure.fromException(
          Exception('User with this name already exists'),
        );
      }

      final user = AppUser(
        id: '',
        uniqueName: uniqueName.trim(),
        phoneNumber: phoneNumber.trim(),
        totalDebitMoney: 0.0,
        totalMoneyOwed: 0.0,
        debitItems: [],
      );

      final docRef = await _usersRef.add(user.toMap());
      return docRef.id;
    } on FirebaseFailure {
      rethrow; // Re-throw custom failures
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to create user: $e'),
      );
    }
  }

  /// Get all users with better error handling
  Future<List<AppUser>> getAllUsers() async {
    try {
      final snapshot = await _usersRef.get();
      return _mapSnapshotToUsers(snapshot);
    } catch (error) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get users: $error'),
      );
    }
  }

  /// Get user by ID with consistent error handling

  /// Get user by unique name with better performance
  Future<AppUser?> getUserByName(String uniqueName) async {
    try {
      if (uniqueName.trim().isEmpty) {
        throw ArgumentError('Unique name cannot be empty');
      }

      final snapshot = await _usersRef
          .where(_uniqueNameField, isEqualTo: uniqueName.trim())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user by name: $e'),
      );
    }
  }

  Future<AppUser?> getUserById(String userId) async {
    try {
      _validateUserId(userId);

      final doc = await _usersRef.doc(userId).get();
      return doc.exists
          ? AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          : null;
    } catch (e) {
      throw FirebaseFailure.fromException(Exception('Failed to get user: $e'));
    }
  }

  /// Update user information with improved validation
  Future<void> updateUser({
    required String userId,
    String? uniqueName,
    String? phoneNumber,
  }) async {
    try {
      _validateUserId(userId);

      final Map<String, dynamic> updates = {};

      if (uniqueName != null) {
        final trimmedName = uniqueName.trim();
        if (trimmedName.isEmpty) {
          throw ArgumentError('Unique name cannot be empty');
        }

        // Check uniqueness excluding current user
        if (await _isUniqueNameTaken(trimmedName, excludeUserId: userId)) {
          throw FirebaseFailure.fromException(
            Exception('User with this name already exists'),
          );
        }
        updates[_uniqueNameField] = trimmedName;
      }

      if (phoneNumber != null) {
        final trimmedPhone = phoneNumber.trim();
        if (trimmedPhone.isEmpty) {
          throw ArgumentError('Phone number cannot be empty');
        }
        updates[_phoneNumberField] = trimmedPhone;
      }

      if (updates.isNotEmpty) {
        await _usersRef.doc(userId).update(updates);
      }
    } catch (e) {
      if (e is FirebaseFailure || e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update user: $e'),
      );
    }
  }

  /// Delete user and all debit items using transaction for consistency
  Future<void> deleteUser(String userId) async {
    try {
      _validateUserId(userId);

      // Use transaction for atomicity
      await _firestore.runTransaction((transaction) async {
        // Get all debit items
        final debitItems = await _debitItemsRef(userId).get();

        // Delete all debit items
        for (final doc in debitItems.docs) {
          transaction.delete(doc.reference);
        }

        // Delete user
        transaction.delete(_usersRef.doc(userId));
      });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete user: $e'),
      );
    }
  }

  ///  ******************************************************************************************

  // ============ DEBIT ITEM FUNCTIONS ============

  /// FIXED: Add debit item with automatic timestamp and total calculation
  Future<String> addDebitItem({
    required String userId,
    required String recordName,
    required double recordMoneyValue,
    required String status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _validateUserId(userId);
      _validateDebitItemInput(recordName, recordMoneyValue, status);

      // Create debit item with server timestamp for proper sorting
      final debitItemData = {
        'recordName': recordName.trim(),
        'recordMoneyValue': recordMoneyValue,
        'status': status.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        if (additionalFields != null) 'additionalFields': additionalFields,
      };

      // Use transaction to ensure consistency
      late String docId;
      await _firestore.runTransaction((transaction) async {
        // Read debit items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _debitItemsRef(userId).get();
        
        // Add new item
        final docRef = _debitItemsRef(userId).doc();
        transaction.set(docRef, debitItemData);
        docId = docRef.id;

        // Update user totals (synchronously)
        _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, newItem: {
          'recordMoneyValue': recordMoneyValue,
          'status': status.trim().toLowerCase(),
        });
      });

      log('Added debit item with ID: $docId for user: $userId');
      return docId;
    } catch (e) {
      log('Error adding debit item: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to add debit item: $e'),
      );
    }
  }

  /// Get debit items with time-based sorting (newest first by default)
  Future<List<DebitItem>> getDebitItems(
    String userId, {
    bool sortByTimeDescending = true,
  }) async {
    try {
      _validateUserId(userId);

      Query query = _debitItemsRef(userId);

      // Try to order by createdAt, fall back to no ordering if field doesn't exist
      try {
        query = query.orderBy(
          _createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log(
          'Warning: Could not sort by createdAt field, returning unsorted results',
        );
        query = _debitItemsRef(userId);
      }

      final snapshot = await query.get();
      final items = _mapSnapshotToDebitItems(snapshot);

      // If Firestore ordering failed and we need to sort in memory
      // Note: This requires your DebitItem model to have a createdAt field
      // If your model doesn't have createdAt, this section will be skipped
      if (sortByTimeDescending && items.isNotEmpty) {
        try {
          // Only attempt to sort if DebitItem has createdAt field
          // Remove this block if your DebitItem doesn't have createdAt
          log(
            'Note: In-memory sorting skipped - DebitItem model may not have createdAt field',
          );

        } catch (e) {
          log('Warning: Could not sort items by time in memory: $e');
        }
      }

      log('Retrieved ${items.length} debit items for user: $userId');
      return items;
    } catch (e) {
      log('Error getting debit items: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to get debit items: $e'),
      );
    }
  }

  /// FIXED: Delete debit item with automatic total recalculation
  Future<void> deleteDebitItem(String userId, String debitItemId) async {
    try {
      _validateUserId(userId);
      _validateDebitItemId(debitItemId);

      await _firestore.runTransaction((transaction) async {
        // Read debit items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _debitItemsRef(userId).get();
        
        // Delete the specific item
        transaction.delete(_debitItemsRef(userId).doc(debitItemId));
        
        // Update user totals (synchronously, excluding the deleted item)
        _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, 
          excludeItemId: debitItemId);
      });

      log('Deleted debit item: $debitItemId for user: $userId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete debit item: $e'),
      );
    }
  }

  /// Get debit items stream with time-based sorting
  Stream<List<DebitItem>> getDebitItemsStream(
    String userId, {
    bool sortByTimeDescending = true,
  }) {
    try {
      _validateUserId(userId);

      Query query = _debitItemsRef(userId);

      try {
        query = query.orderBy(
          _createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log('Warning: Could not sort stream by createdAt field');
        query = _debitItemsRef(userId);
      }

      return query
          .snapshots()
          .map((snapshot) => _mapSnapshotToDebitItems(snapshot))
          .handleError((error) {
            log('Stream error: $error');
            throw FirebaseFailure.fromException(
              Exception('Failed to get debit items stream: $error'),
            );
          });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to initialize debit items stream: $e'),
      );
    }
  }

  /// Get debit item by ID
  Future<DebitItem?> getDebitItemById(String userId, String debitItemId) async {
    try {
      _validateUserId(userId);
      _validateDebitItemId(debitItemId);

      final doc = await _debitItemsRef(userId).doc(debitItemId).get();
      return doc.exists
          ? DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          : null;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get debit item: $e'),
      );
    }
  }

  /// FIXED: Update debit item with automatic total recalculation
  Future<void> updateDebitItem({
    required String userId,
    required String debitItemId,
    String? recordName,
    double? recordMoneyValue,
    String? status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _validateUserId(userId);
      _validateDebitItemId(debitItemId);

      final Map<String, dynamic> updates = {};

      if (recordName != null) {
        final trimmed = recordName.trim();
        if (trimmed.isEmpty) throw ArgumentError('Record name cannot be empty');
        updates['recordName'] = trimmed;
      }

      if (recordMoneyValue != null) {
        if (recordMoneyValue < 0) {
          throw ArgumentError('Money value cannot be negative');
        }
        updates[_recordMoneyValueField] = recordMoneyValue;
      }

      if (status != null) {
        final trimmed = status.trim();
        if (trimmed.isEmpty) throw ArgumentError('Status cannot be empty');
        updates[_statusField] = trimmed.toLowerCase();
      }

      if (additionalFields != null) {
        updates['additionalFields'] = additionalFields;
      }

      if (updates.isNotEmpty) {
        await _firestore.runTransaction((transaction) async {
          // Read debit items first (outside transaction since it's a collection)
          final debitItemsSnapshot = await _debitItemsRef(userId).get();
          
          // Update the item
          transaction.update(_debitItemsRef(userId).doc(debitItemId), updates);
          
          // Update user totals (synchronously, with updated values)
          _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, 
            updateItemId: debitItemId, 
            updatedValues: updates);
        });

        log('Updated debit item: $debitItemId for user: $userId');
      }
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update debit item: $e'),
      );
    }
  }

  /// Get debit items by status with time-based sorting
  Stream<List<DebitItem>> getDebitItemsByStatus(
    String userId,
    String status, {
    bool sortByTimeDescending = true,
  }) {
    try {
      _validateUserId(userId);
      if (status.trim().isEmpty) {
        throw ArgumentError('Status cannot be empty');
      }

      Query query = _debitItemsRef(
        userId,
      ).where(_statusField, isEqualTo: status.trim().toLowerCase());

      try {
        query = query.orderBy(
          _createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log('Warning: Could not sort by status stream by createdAt field');
      }

      return query
          .snapshots()
          .map((snapshot) => _mapSnapshotToDebitItems(snapshot))
          .handleError((error) {
            throw FirebaseFailure.fromException(
              Exception('Failed to get debit items by status: $error'),
            );
          });
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to initialize debit items by status stream: $e'),
      );
    }
  }

  // ============ TOTAL CALCULATION FUNCTIONS ============

  /// Get total debit money for a specific user (sum of all recordMoneyValue)
  Future<double> getTotalDebitMoney(String userId) async {
    try {
      _validateUserId(userId);

      final debitItemsSnapshot = await _debitItemsRef(userId).get();
      double totalDebitMoney = 0.0;

      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
        totalDebitMoney += money;
      }

      log('Calculated total debit money for user $userId: $totalDebitMoney');
      return totalDebitMoney;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get total debit money: $e'),
      );
    }
  }

  Future<double> getTotalOwnedMoney(String userId) async {
    try {
      _validateUserId(userId);

      final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
      double totalOwnedMoney = 0.0;

      for (final doc in ownedItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
        totalOwnedMoney += money;
      }

      log('Calculated total owned money for user $userId: $totalOwnedMoney');
      return totalOwnedMoney;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get total owned money: $e'),
      );
    }
  }

  /// Get total debit money for all users
  Future<Map<String, double>> getAllUsersTotalDebitMoney() async {
    try {
      final usersSnapshot = await _usersRef.get();
      final Map<String, double> userTotals = {};

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final totalMoney = await getTotalDebitMoney(userId);
        userTotals[userId] = totalMoney;
      }

      log('Calculated totals for ${userTotals.length} users');
      return userTotals;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get all users total debit money: $e'),
      );
    }
  }

  /// Update all users' total debit money (useful for data migration)
  Future<void> recalculateAllUsersTotals() async {
    try {
      final usersSnapshot = await _usersRef.get();

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        await recalculateUserTotals(userId);
      }

      log('Recalculated totals for ${usersSnapshot.docs.length} users');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to recalculate all users totals: $e'),
      );
    }
  }

  // ============ HELPER FUNCTIONS ============

  /// FIXED: Update user totals with better error handling
  Future<void> _updateUserTotals(String userId) async {
    await _firestore.runTransaction((transaction) async {
      final debitItemsSnapshot = await _debitItemsRef(userId).get();
      _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot);
    });
  }

  /// FIXED: Update user totals within a transaction - NO MORE ASYNC/AWAIT
  void _updateUserTotalsInTransaction(
    Transaction transaction,
    String userId,
    QuerySnapshot debitItemsSnapshot, {
    String? excludeItemId,
    String? updateItemId,
    Map<String, dynamic>? updatedValues,
    Map<String, dynamic>? newItem,
  }) {
    try {
      // Process the documents with modifications
      List<Map<String, dynamic>> processedDocs = [];
      
      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Skip if this is the item being deleted
        if (excludeItemId != null && doc.id == excludeItemId) {
          continue;
        }
        
        // Update values if this is the item being updated
        if (updateItemId != null && doc.id == updateItemId && updatedValues != null) {
          final updatedData = Map<String, dynamic>.from(data);
          updatedData.addAll(updatedValues);
          processedDocs.add(updatedData);
        } else {
          processedDocs.add(data);
        }
      }
      
      // Add new item if provided
      if (newItem != null) {
        processedDocs.add(newItem);
      }
      
      // Calculate totals from processed documents
      final totals = _calculateTotalsFromMaps(processedDocs);

      transaction.update(_usersRef.doc(userId), {
        _totalDebitMoneyField: totals.totalMoney,
        _totalMoneyOwedField: totals.totalOwed,
      });

      log(
        'Updated user totals for $userId: total=${totals.totalMoney}, owed=${totals.totalOwed}',
      );
    } catch (e) {
      log('Error updating user totals in transaction: $e');
      rethrow;
    }
  }

  /// ADDED: Helper method to calculate totals from processed maps
  ({double totalMoney, double totalOwed}) _calculateTotalsFromMaps(
    List<Map<String, dynamic>> docs,
  ) {
    double totalMoney = 0.0;
    double totalOwed = 0.0;

    for (final data in docs) {
      final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
      final status = (data[_statusField] ?? '').toString().toLowerCase();

      totalMoney += money;

      if (_owedStatuses.contains(status)) {
        totalOwed += money;
      }
    }

    return (totalMoney: totalMoney, totalOwed: totalOwed);
  }

  /// Manually recalculate totals for a specific user
  Future<void> recalculateUserTotals(String userId) async {
    try {
      _validateUserId(userId);
      await _updateUserTotals(userId);
      log('Manually recalculated totals for user: $userId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to recalculate user totals: $e'),
      );
    }
  }

  /// Get comprehensive user statistics
  Future<UserStatistics> getUserStatistics(String userId) async {
    try {
      _validateUserId(userId);

      final debitItemsSnapshot = await _debitItemsRef(userId).get();
      final docs = debitItemsSnapshot.docs;

      final statusCount = <String, int>{};
      final statusTotal = <String, double>{};
      final totals = _calculateTotals(docs);

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = (data[_statusField] ?? 'unknown')
            .toString()
            .toLowerCase();
        final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();

        statusCount[status] = (statusCount[status] ?? 0) + 1;
        statusTotal[status] = (statusTotal[status] ?? 0.0) + money;
      }

      return UserStatistics(
        totalItems: docs.length,
        totalMoney: totals.totalMoney,
        totalOwed: totals.totalOwed,
        statusCount: statusCount,
        statusTotal: statusTotal,
      );
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user statistics: $e'),
      );
    }
  }

  /// Enhanced search with better query handling
  Future<List<AppUser>> searchUsersByName(String query) async {
    try {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) return [];

      final snapshot = await _usersRef
          .where(_uniqueNameField, isGreaterThanOrEqualTo: trimmedQuery)
          .where(_uniqueNameField, isLessThanOrEqualTo: '$trimmedQuery\uf8ff')
          .limit(50) // Add limit for performance
          .get();

      return _mapSnapshotToUsers(snapshot);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to search users: $e'),
      );
    }
  }

  // ============ PRIVATE HELPER METHODS ============

  /// Check if unique name is taken
  Future<bool> _isUniqueNameTaken(
    String uniqueName, {
    String? excludeUserId,
  }) async {
    final query = await _usersRef
        .where(_uniqueNameField, isEqualTo: uniqueName)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return false;

    // If excluding a user ID, check if the found user is different
    if (excludeUserId != null) {
      return query.docs.first.id != excludeUserId;
    }

    return true;
  }

  /// Calculate totals from documents - Core logic for FEATURE 1
  ({double totalMoney, double totalOwed}) _calculateTotals(
    List<QueryDocumentSnapshot> docs,
  ) {
    double totalMoney = 0.0; // Sum of ALL recordMoneyValue (totalDebitMoney)
    double totalOwed = 0.0; // Sum of recordMoneyValue where status is owed

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
      final status = (data[_statusField] ?? '').toString().toLowerCase();

      // FEATURE 1: Add ALL money values to totalMoney (becomes totalDebitMoney)
      totalMoney += money;

      // Only add to owed if status indicates money is still owed
      if (_owedStatuses.contains(status)) {
        totalOwed += money;
      }
    }

    return (totalMoney: totalMoney, totalOwed: totalOwed);
  }

  /// Map snapshot to users list
  List<AppUser> _mapSnapshotToUsers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } catch (e) {
        log('Error mapping user document ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }

  /// Map snapshot to debit items list
  List<DebitItem> _mapSnapshotToDebitItems(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } catch (e) {
        log('Error mapping debit item document ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }

  // ============ VALIDATION METHODS ============

  void _validateUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
  }

  void _validateDebitItemId(String debitItemId) {
    if (debitItemId.trim().isEmpty) {
      throw ArgumentError('Debit item ID cannot be empty');
    }
  }

  void _validateUserInput(String uniqueName, String phoneNumber) {
    if (uniqueName.trim().isEmpty) {
      throw ArgumentError('Unique name cannot be empty');
    }
    if (phoneNumber.trim().isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
  }

  void _validateDebitItemInput(
    String recordName,
    double recordMoneyValue,
    String status,
  ) {
    if (recordName.trim().isEmpty) {
      throw ArgumentError('Record name cannot be empty');
    }
    if (recordMoneyValue < 0) {
      throw ArgumentError('Record money value cannot be negative');
    }
    if (status.trim().isEmpty) {
      throw ArgumentError('Status cannot be empty');
    }
  }
}

/// Data class for user statistics
class UserStatistics {
  final int totalItems;
  final double totalMoney;
  final double totalOwed;
  final Map<String, int> statusCount;
  final Map<String, double> statusTotal;

  const UserStatistics({
    required this.totalItems,
    required this.totalMoney,
    required this.totalOwed,
    required this.statusCount,
    required this.statusTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalItems': totalItems,
      'totalMoney': totalMoney,
      'totalOwed': totalOwed,
      'statusCount': statusCount,
      'statusTotal': statusTotal,
    };
  }

  @override
  String toString() {
    return 'UserStatistics(totalItems: $totalItems, totalMoney: $totalMoney, totalOwed: $totalOwed)';
  }
}