import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia_admin/core/utils/errors/firebase_failures.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';

/// Enhanced FirestoreService with improved error handling, performance, and maintainability
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constants for better maintainability
  static const String _usersCollection = 'users';
  static const String _debitItemsCollection = 'debitItems';
  static const String _uniqueNameField = 'uniqueName';
  static const String _phoneNumberField = 'phoneNumber';
  static const String _statusField = 'status';
  static const String _createdAtField = 'createdAt';
  static const String _recordMoneyValueField = 'recordMoneyValue';
  static const String _totalDebitMoneyField = 'totalDebitMoney';
  static const String _totalMoneyOwedField = 'totalMoneyOwed';

  // Owed status constants
  static const Set<String> _owedStatuses = {'pending', 'unpaid', 'overdue'}
  /*
  IMPORTANT: You need to add this copyWith method to your AppUser model class:
  
  AppUser copyWith({
    String? id,
    String? uniqueName,
    String? phoneNumber,
    List<DebitItem>? debitItems,
    double? totalDebitMoney,
    double? totalMoneyOwed,
  }) {
    return AppUser(
      id: id ?? this.id,
      uniqueName: uniqueName ?? this.uniqueName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      debitItems: debitItems ?? this.debitItems,
      totalDebitMoney: totalDebitMoney ?? this.totalDebitMoney,
      totalMoneyOwed: totalMoneyOwed ?? this.totalMoneyOwed,
    );
  }
*/
  ;

  // Collection references with better naming
  CollectionReference get _usersRef => _firestore.collection(_usersCollection);
  CollectionReference _debitItemsRef(String userId) =>
      _usersRef.doc(userId).collection(_debitItemsCollection);

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

  /// Get all users as a stream with better error handling
  Future<List<AppUser>> getAllUsers() async {
    try {
      final snapshot = await _usersRef.get(); // one-time fetch from Firestore
      return _mapSnapshotToUsers(snapshot);
    } catch (error) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get users: $error'),
      );
    }
  }

  /// Get user by ID with consistent error handling
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

  // ============ DEBIT ITEM FUNCTIONS ============

  /// Add debit item with transaction for consistency
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

      final debitItem = DebitItem(
        id: '',
        recordName: recordName.trim(),
        recordMoneyValue: recordMoneyValue,
        status: status.trim().toLowerCase(),
        additionalFields: additionalFields,
      );

      // Use transaction to ensure consistency
      late String docId;
      await _firestore.runTransaction((transaction) async {
        final docRef = _debitItemsRef(userId).doc();
        transaction.set(docRef, debitItem.toMap());
        docId = docRef.id;

        // Update totals in the same transaction
        await _updateUserTotalsInTransaction(transaction, userId);
      });

      return docId;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to add debit item: $e'),
      );
    }
  }

  /// Get user with all their debit items by user ID
  Future<AppUser?> getUserWithDebitItems(String userId) async {
    try {
      _validateUserId(userId);

      // Get user data
      final userDoc = await _usersRef.doc(userId).get();
      if (!userDoc.exists) return null;

      // Get debit items
      final debitItemsSnapshot = await _debitItemsRef(
        userId,
      ).orderBy(_createdAtField, descending: true).get();

      final debitItems = _mapSnapshotToDebitItems(debitItemsSnapshot);

      // Create AppUser with debit items
      final userData = userDoc.data() as Map<String, dynamic>;
      final appUser = AppUser.fromMap(userData, userDoc.id);
      // Manually create a new AppUser with debitItems since copyWith is not defined
      return AppUser(
        id: appUser.id,
        uniqueName: appUser.uniqueName,
        phoneNumber: appUser.phoneNumber,
        totalDebitMoney: appUser.totalDebitMoney,
        totalMoneyOwed: appUser.totalMoneyOwed,
        debitItems: debitItems,
        // Add any other fields from AppUser as needed
      );
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user with debit items: $e'),
      );
    }
  }

  /// Get user with all their debit items by unique name
  Future<AppUser?> getUserWithDebitItemsByName(String uniqueName) async {
    try {
      if (uniqueName.trim().isEmpty) {
        throw ArgumentError('Unique name cannot be empty');
      }

      // First get user by unique name
      final userSnapshot = await _usersRef
          .where(_uniqueNameField, isEqualTo: uniqueName.trim())
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) return null;

      final userDoc = userSnapshot.docs.first;
      final userId = userDoc.id;

      // Get debit items for this user
      final debitItemsSnapshot = await _debitItemsRef(
        userId,
      ).orderBy(_createdAtField, descending: true).get();

      final debitItems = _mapSnapshotToDebitItems(debitItemsSnapshot);

      // Create AppUser with debit items
      final userData = userDoc.data() as Map<String, dynamic>;
      final appUser = AppUser.fromMap(userData, userId);
      // If AppUser does not have a copyWith method, create a new instance with debitItems manually
      return AppUser(
        id: appUser.id,
        uniqueName: appUser.uniqueName,
        // Add other fields from appUser as needed
        debitItems: appUser.debitItems,
        phoneNumber: appUser.phoneNumber,
        totalDebitMoney: appUser.totalDebitMoney,
        totalMoneyOwed: appUser.totalMoneyOwed,
      );
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user with debit items by name: $e'),
      );
    }
  }

  /// Get all users with their debit items (use with caution for large datasets)

  /*
  Future<List<AppUser>> getAllUsersWithDebitItems() async {
    try {
      final usersSnapshot = await _usersRef.get();
      final List<AppUser> usersWithDebitItems = [];

      for (final userDoc in usersSnapshot.docs) {
        // Get debit items for each user
        final debitItemsSnapshot = await _debitItemsRef(userDoc.id)
            .orderBy(_createdAtField, descending: true)
            .get();

        final debitItems = _mapSnapshotToDebitItems(debitItemsSnapshot);
        
        final userData = userDoc.data() as Map<String, dynamic>;
        final appUser = AppUser.fromMap(userData, userDoc.id);
        // Manually create a new AppUser with debitItems since copyWith is not defined
        final userWithDebitItems = AppUser(
          id: appUser.id,
          uniqueName: appUser.uniqueName,
          phoneNumber: appUser.phoneNumber,
          totalDebitMoney: appUser.totalDebitMoney,
          totalMoneyOwed: appUser.totalMoneyOwed,
          debitItems: debitItems,
          // Add other fields from appUser as needed
        );
        usersWithDebitItems.add(userWithDebitItems);

      return usersWithDebitItems;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get all users with debit items: $e'),
      );
    }
  }
  */

  /// Get users with debit items filtered by status

  /*
  Future<List<AppUser>> getUsersWithDebitItemsByStatus(String status) async {
    try {
      if (status.trim().isEmpty) {
        throw ArgumentError('Status cannot be empty');
      }

      final usersSnapshot = await _usersRef.get();
      final List<AppUser> usersWithFilteredDebitItems = [];

      for (final userDoc in usersSnapshot.docs) {
        // Get filtered debit items for each user
        final debitItemsSnapshot = await _debitItemsRef(userDoc.id)
            .where(_statusField, isEqualTo: status.trim().toLowerCase())
            .orderBy(_createdAtField, descending: true)
            .get();

        final debitItems = _mapSnapshotToDebitItems(debitItemsSnapshot);
        
        // Only include users who have debit items with the specified status
        if (debitItems.isNotEmpty) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final appUser = AppUser.fromMap(userData, userDoc.id);
          // Manually create a new AppUser with debitItems since copyWith is not defined
          final userWithDebitItems = AppUser(
            id: appUser.id,
            uniqueName: appUser.uniqueName,
            phoneNumber: appUser.phoneNumber,
            totalDebitMoney: appUser.totalDebitMoney,
            totalMoneyOwed: appUser.totalMoneyOwed,
            debitItems: debitItems,
            // Add other fields from appUser as needed
          );
          usersWithFilteredDebitItems.add(userWithDebitItems);
        }

      return usersWithFilteredDebitItems;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get users with debit items by status: $e'),
      );
    }
  }

*/

  /// Get user's debit items within a date range
  Future<List<DebitItem>> getUserDebitItemsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _validateUserId(userId);

      if (startDate.isAfter(endDate)) {
        throw ArgumentError('Start date cannot be after end date');
      }

      final snapshot = await _debitItemsRef(userId)
          .where(
            _createdAtField,
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where(
            _createdAtField,
            isLessThanOrEqualTo: Timestamp.fromDate(endDate),
          )
          .orderBy(_createdAtField, descending: true)
          .get();

      return _mapSnapshotToDebitItems(snapshot);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user debit items by date range: $e'),
      );
    }
  }

  /// Get aggregated data for all users with debit items
  Future<Map<String, dynamic>> getAggregatedDebitData() async {
    try {
      final usersSnapshot = await _usersRef.get();

      int totalUsers = usersSnapshot.docs.length;
      int totalDebitItems = 0;
      double totalDebitMoney = 0.0;
      double totalMoneyOwed = 0.0;
      Map<String, int> statusCount = {};
      Map<String, double> statusTotal = {};

      for (final userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        totalDebitMoney += (userData[_totalDebitMoneyField] ?? 0.0).toDouble();
        totalMoneyOwed += (userData[_totalMoneyOwedField] ?? 0.0).toDouble();

        // Get debit items for detailed status analysis
        final debitItemsSnapshot = await _debitItemsRef(userDoc.id).get();
        totalDebitItems += debitItemsSnapshot.docs.length;

        for (final debitDoc in debitItemsSnapshot.docs) {
          final debitData = debitDoc.data() as Map<String, dynamic>;
          final status = (debitData[_statusField] ?? 'unknown')
              .toString()
              .toLowerCase();
          final money = (debitData[_recordMoneyValueField] ?? 0.0).toDouble();

          statusCount[status] = (statusCount[status] ?? 0) + 1;
          statusTotal[status] = (statusTotal[status] ?? 0.0) + money;
        }
      }

      return {
        'totalUsers': totalUsers,
        'totalDebitItems': totalDebitItems,
        'totalDebitMoney': totalDebitMoney,
        'totalMoneyOwed': totalMoneyOwed,
        'statusCount': statusCount,
        'statusTotal': statusTotal,
        'averageDebitPerUser': totalUsers > 0
            ? totalDebitMoney / totalUsers
            : 0.0,
        'averageItemsPerUser': totalUsers > 0
            ? totalDebitItems / totalUsers
            : 0.0,
      };
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get aggregated debit data: $e'),
      );
    }
  }

  /// Get debit items for a specific user
  Future<List<DebitItem>> getDebitItems(String userId) async {
    try {
      _validateUserId(userId);

      final snapshot = await _debitItemsRef(
        userId,
      ).orderBy(_createdAtField, descending: true).get();

      return _mapSnapshotToDebitItems(snapshot);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get debit items: $e'),
      );
    }
  }

  /// Get debit items stream for real-time updates
  Stream<List<DebitItem>> getDebitItemsStream(String userId) {
    try {
      _validateUserId(userId);

      return _debitItemsRef(userId)
          .orderBy(_createdAtField, descending: true)
          .snapshots()
          .map((snapshot) => _mapSnapshotToDebitItems(snapshot))
          .handleError((error) {
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

  /// Update debit item with transaction
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
        if (recordMoneyValue < 0)
          throw ArgumentError('Money value cannot be negative');
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
          transaction.update(_debitItemsRef(userId).doc(debitItemId), updates);
          await _updateUserTotalsInTransaction(transaction, userId);
        });
      }
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update debit item: $e'),
      );
    }
  }

  /// Delete debit item with transaction
  Future<void> deleteDebitItem(String userId, String debitItemId) async {
    try {
      _validateUserId(userId);
      _validateDebitItemId(debitItemId);

      await _firestore.runTransaction((transaction) async {
        transaction.delete(_debitItemsRef(userId).doc(debitItemId));
        await _updateUserTotalsInTransaction(transaction, userId);
      });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete debit item: $e'),
      );
    }
  }

  /// Get debit items by status with validation
  Stream<List<DebitItem>> getDebitItemsByStatus(String userId, String status) {
    try {
      _validateUserId(userId);
      if (status.trim().isEmpty) {
        throw ArgumentError('Status cannot be empty');
      }

      return _debitItemsRef(userId)
          .where(_statusField, isEqualTo: status.trim().toLowerCase())
          .orderBy(_createdAtField, descending: true)
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

  // ============ HELPER FUNCTIONS ============

  /// Update user totals with better error handling
  Future<void> _updateUserTotals(String userId) async {
    await _firestore.runTransaction((transaction) async {
      await _updateUserTotalsInTransaction(transaction, userId);
    });
  }

  /// Update user totals within a transaction
  Future<void> _updateUserTotalsInTransaction(
    Transaction transaction,
    String userId,
  ) async {
    try {
      final debitItemsSnapshot = await _debitItemsRef(userId).get();
      final totals = _calculateTotals(debitItemsSnapshot.docs);

      transaction.update(_usersRef.doc(userId), {
        _totalDebitMoneyField: totals.totalMoney,
        _totalMoneyOwedField: totals.totalOwed,
      });
    } catch (e) {
      print('Error updating user totals in transaction: $e');
      rethrow;
    }
  }

  /// Manually recalculate totals
  Future<void> recalculateUserTotals(String userId) async {
    try {
      _validateUserId(userId);
      await _updateUserTotals(userId);
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to recalculate user totals: $e'),
      );
    }
  }

  /// Get user statistics with improved structure
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

  /// Calculate totals from documents
  ({double totalMoney, double totalOwed}) _calculateTotals(
    List<QueryDocumentSnapshot> docs,
  ) {
    double totalMoney = 0.0;
    double totalOwed = 0.0;

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
      final status = (data[_statusField] ?? '').toString().toLowerCase();

      totalMoney += money;

      if (_owedStatuses.contains(status)) {
        totalOwed += money;
      }
    }

    return (totalMoney: totalMoney, totalOwed: totalOwed);
  }

  /// Map snapshot to users list
  List<AppUser> _mapSnapshotToUsers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  /// Map snapshot to debit items list
  List<DebitItem> _mapSnapshotToDebitItems(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DebitItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
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
}
