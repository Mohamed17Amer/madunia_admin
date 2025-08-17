import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madunia_admin/core/utils/errors/firebase_failures.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';
import 'package:madunia_admin/features/owned_report/data/models/owned_item_model.dart';

/// Enhanced FirestoreService with improved error handling, performance, and maintainability
/// Features:
/// - Automatic totalDebitMoney calculation (sum of all recordMoneyValue)
/// - Automatic totalOwnedMoney calculation (sum of all owned items recordMoneyValue)
/// - Time-based sorting for debit items (newest first by default)
/// - Robust error handling and validation
/// - Transaction-based consistency
/// - Owned items management
/// - Automatic monthly debit items addition
class FirestoreService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constants for better maintainability
  static const String _usersCollection = 'users';
  static const String _debitItemsCollection = 'debitItems';
  static const String _ownedItemsCollection = 'ownedItems';
  static const String _monthlyDebitsCollection = 'monthlyDebits';
  static const String _systemCollection = 'system';
  static const String _uniqueNameField = 'uniqueName';
  static const String _phoneNumberField = 'phoneNumber';
  static const String _statusField = 'status';
  static const String _createdAtField = 'createdAt';
  static const String _recordMoneyValueField = 'recordMoneyValue';
  static const String _totalDebitMoneyField = 'totalDebitMoney';
  static const String _totalMoneyOwedField = 'totalMoneyOwed';
  static const String _totalOwnedMoneyField = 'totalOwnedMoney';

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

  // monthly debits template collection
  CollectionReference get _monthlyDebitsRef => 
      _firestore.collection(_monthlyDebitsCollection);

  // system collection for tracking last execution
  CollectionReference get _systemRef => 
      _firestore.collection(_systemCollection);

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
        totalOwnedMoney: 0.0, // Added totalOwnedMoney
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
        
        // Get all owned items
        final ownedItems = await _ownedItemsRef(userId).get();

        // Delete all debit items
        for (final doc in debitItems.docs) {
          transaction.delete(doc.reference);
        }

        // Delete all owned items
        for (final doc in ownedItems.docs) {
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
        final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
        
        // Add new item
        final docRef = _debitItemsRef(userId).doc();
        transaction.set(docRef, debitItemData);
        docId = docRef.id;

        // Update user totals (synchronously)
        _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, newDebitItem: {
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
        final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
        
        // Delete the specific item
        transaction.delete(_debitItemsRef(userId).doc(debitItemId));
        
        // Update user totals (synchronously, excluding the deleted item)
        _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
          excludeDebitItemId: debitItemId);
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
          final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
          
          // Update the item
          transaction.update(_debitItemsRef(userId).doc(debitItemId), updates);
          
          // Update user totals (synchronously, with updated values)
          _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
            updateDebitItemId: debitItemId, 
            updatedDebitValues: updates);
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

  ///  ******************************************************************************************

  // ============ OWNED ITEM FUNCTIONS ============

  /// Add owned item with automatic timestamp and total calculation
  Future<String> addOwnedItem({
    required String userId,
    required String recordName,
    required double recordMoneyValue,
    required String status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _validateUserId(userId);
      _validateOwnedItemInput(recordName, recordMoneyValue, status);

      // Create owned item with server timestamp for proper sorting
      final ownedItemData = {
        'recordName': recordName.trim(),
        'recordMoneyValue': recordMoneyValue,
        'status': status.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        if (additionalFields != null) 'additionalFields': additionalFields,
      };

      // Use transaction to ensure consistency
      late String docId;
      await _firestore.runTransaction((transaction) async {
        // Read items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _debitItemsRef(userId).get();
        final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
        
        // Add new item
        final docRef = _ownedItemsRef(userId).doc();
        transaction.set(docRef, ownedItemData);
        docId = docRef.id;

        // Update user totals (synchronously)
        _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, newOwnedItem: {
          'recordMoneyValue': recordMoneyValue,
          'status': status.trim().toLowerCase(),
        });
      });

      log('Added owned item with ID: $docId for user: $userId');
      return docId;
    } catch (e) {
      log('Error adding owned item: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to add owned item: $e'),
      );
    }
  }

  /// Get owned items with time-based sorting (newest first by default)
  Future<List<OwnedItem>> getOwnedItems(
    String userId, {
    bool sortByTimeDescending = true,
  }) async {
    try {
      _validateUserId(userId);

      Query query = _ownedItemsRef(userId);

      // Try to order by createdAt, fall back to no ordering if field doesn't exist
      try {
        query = query.orderBy(
          _createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log(
          'Warning: Could not sort owned items by createdAt field, returning unsorted results',
        );
        query = _ownedItemsRef(userId);
      }

      final snapshot = await query.get();
      final items = _mapSnapshotToOwnedItems(snapshot);

      log('Retrieved ${items.length} owned items for user: $userId');
      return items;
    } catch (e) {
      log('Error getting owned items: $e');
      throw FirebaseFailure.fromException(
        Exception('Failed to get owned items: $e'),
      );
    }
  }

  /// Delete owned item with automatic total recalculation
  Future<void> deleteOwnedItem(String userId, String ownedItemId) async {
    try {
      _validateUserId(userId);
      _validateOwnedItemId(ownedItemId);

      await _firestore.runTransaction((transaction) async {
        // Read items first (outside transaction since it's a collection)
        final debitItemsSnapshot = await _debitItemsRef(userId).get();
        final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
        
        // Delete the specific item
        transaction.delete(_ownedItemsRef(userId).doc(ownedItemId));
        
        // Update user totals (synchronously, excluding the deleted item)
        _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
          excludeOwnedItemId: ownedItemId);
      });

      log('Deleted owned item: $ownedItemId for user: $userId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to delete owned item: $e'),
      );
    }
  }

  /// Get owned items stream with time-based sorting
  Stream<List<OwnedItem>> getOwnedItemsStream(
    String userId, {
    bool sortByTimeDescending = true,
  }) {
    try {
      _validateUserId(userId);

      Query query = _ownedItemsRef(userId);

      try {
        query = query.orderBy(
          _createdAtField,
          descending: sortByTimeDescending,
        );
      } catch (e) {
        log('Warning: Could not sort owned items stream by createdAt field');
        query = _ownedItemsRef(userId);
      }

      return query
          .snapshots()
          .map((snapshot) => _mapSnapshotToOwnedItems(snapshot))
          .handleError((error) {
            log('Owned items stream error: $error');
            throw FirebaseFailure.fromException(
              Exception('Failed to get owned items stream: $error'),
            );
          });
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to initialize owned items stream: $e'),
      );
    }
  }

  /// Get owned item by ID
  Future<OwnedItem?> getOwnedItemById(String userId, String ownedItemId) async {
    try {
      _validateUserId(userId);
      _validateOwnedItemId(ownedItemId);

      final doc = await _ownedItemsRef(userId).doc(ownedItemId).get();
      return doc.exists
          ? OwnedItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          : null;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get owned item: $e'),
      );
    }
  }

  /// Update owned item with automatic total recalculation
  Future<void> updateOwnedItem({
    required String userId,
    required String ownedItemId,
    String? recordName,
    double? recordMoneyValue,
    String? status,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _validateUserId(userId);
      _validateOwnedItemId(ownedItemId);

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
          // Read items first (outside transaction since it's a collection)
          final debitItemsSnapshot = await _debitItemsRef(userId).get();
          final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
          
          // Update the item
          transaction.update(_ownedItemsRef(userId).doc(ownedItemId), updates);
          
          // Update user totals (synchronously, with updated values)
          _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot, 
            updateOwnedItemId: ownedItemId, 
            updatedOwnedValues: updates);
        });

        log('Updated owned item: $ownedItemId for user: $userId');
      }
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw FirebaseFailure.fromException(
        Exception('Failed to update owned item: $e'),
      );
    }
  }

  ///  ******************************************************************************************

  // ============ AUTOMATIC MONTHLY DEBIT FUNCTIONS ============

  /// Add a monthly debit template for specific user groups or all users
  Future<String> addMonthlyDebitTemplate({
    required String recordName,
    required double recordMoneyValue,
    required String status,
    List<String>? userGroups, // ✅ NEW: Specify which user groups this applies to
    List<String>? specificUserIds, // ✅ NEW: Or specify exact user IDs
    bool applyToAllUsers = true, // ✅ NEW: Default behavior (all users)
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      _validateDebitItemInput(recordName, recordMoneyValue, status);

      // Validate group assignment logic
      if (!applyToAllUsers && (userGroups?.isEmpty ?? true) && (specificUserIds?.isEmpty ?? true)) {
        throw ArgumentError('Must specify userGroups, specificUserIds, or set applyToAllUsers to true');
      }

      final templateData = {
        'recordName': recordName.trim(),
        'recordMoneyValue': recordMoneyValue,
        'status': status.trim().toLowerCase(),
        'isActive': true,
        'applyToAllUsers': applyToAllUsers,
        'userGroups': userGroups ?? [], // Groups this template applies to
        'specificUserIds': specificUserIds ?? [], // Specific users this applies to
        'createdAt': FieldValue.serverTimestamp(),
        if (additionalFields != null) 'additionalFields': additionalFields,
      };

      final docRef = await _monthlyDebitsRef.add(templateData);
      log('Added monthly debit template with ID: ${docRef.id} for ${applyToAllUsers ? "all users" : "specific groups/users"}');
      return docRef.id;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to add monthly debit template: $e'),
      );
    }
  }

  /// Get all active monthly debit templates
  Future<List<MonthlyDebitTemplate>> getMonthlyDebitTemplates() async {
    try {
      final snapshot = await _monthlyDebitsRef
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MonthlyDebitTemplate.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get monthly debit templates: $e'),
      );
    }
  }

  /// Disable a monthly debit template
  Future<void> disableMonthlyDebitTemplate(String templateId) async {
    try {
      await _monthlyDebitsRef.doc(templateId).update({'isActive': false});
      log('Disabled monthly debit template: $templateId');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to disable monthly debit template: $e'),
      );
    }
  }

  /// Execute monthly debits for all users (call this on the 1st of every month)
  /// Now supports user groups and specific user targeting
  Future<void> executeMonthlyDebits() async {
    try {
      final now = DateTime.now();
      
      // Check if we already executed this month
      final systemDoc = await _systemRef.doc('monthly_execution').get();
      if (systemDoc.exists) {
        final lastExecution = (systemDoc.data() as Map<String, dynamic>)['lastExecution'] as Timestamp?;
        if (lastExecution != null) {
          final lastExecutionDate = lastExecution.toDate();
          // If already executed this month, skip
          if (lastExecutionDate.year == now.year && lastExecutionDate.month == now.month) {
            log('Monthly debits already executed for ${now.year}-${now.month}');
            return;
          }
        }
      }

      // Get all active templates
      final templates = await getMonthlyDebitTemplates();
      if (templates.isEmpty) {
        log('No active monthly debit templates found');
        return;
      }

      // Get all users
      final allUsers = await getAllUsers();
      if (allUsers.isEmpty) {
        log('No users found for monthly debit execution');
        return;
      }

      int totalItemsAdded = 0;
      int totalUsersProcessed = 0;
      Map<String, int> templateStats = {}; // Track items per template
      
      // Process each template
      for (final template in templates) {
        try {
          // Determine which users this template applies to
          final targetUsers = _getTargetUsersForTemplate(template, allUsers);
          
          if (targetUsers.isEmpty) {
            log('No target users found for template: ${template.id}');
            continue;
          }

          // Add debit items for target users
          for (final user in targetUsers) {
            try {
              await addDebitItem(
                userId: user.id,
                recordName: '${template.recordName} - ${_getMonthYearString(now)}',
                recordMoneyValue: template.recordMoneyValue,
                status: template.status,
                additionalFields: {
                  'isMonthlyDebit': true,
                  'monthYear': '${now.year}-${now.month.toString().padLeft(2, '0')}',
                  'templateId': template.id,
                  'userGroups': template.userGroups,
                  ...?template.additionalFields,
                },
              );
              totalItemsAdded++;
              templateStats[template.id] = (templateStats[template.id] ?? 0) + 1;
            } catch (e) {
              log('Error adding monthly debit for user ${user.id}, template ${template.id}: $e');
            }
          }
          
          totalUsersProcessed += targetUsers.length;
          log('Applied template "${template.recordName}" to ${targetUsers.length} users');
          
        } catch (e) {
          log('Error processing template ${template.id}: $e');
        }
      }

      // Update execution tracking
      await _systemRef.doc('monthly_execution').set({
        'lastExecution': FieldValue.serverTimestamp(),
        'lastExecutionDetails': {
          'year': now.year,
          'month': now.month,
          'totalUsersInSystem': allUsers.length,
          'totalUsersProcessed': totalUsersProcessed,
          'totalTemplatesProcessed': templates.length,
          'totalItemsAdded': totalItemsAdded,
          'templateStats': templateStats, // How many items per template
        },
      });

      log('Monthly debits executed successfully: $totalItemsAdded items added for $totalUsersProcessed user-template combinations');
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to execute monthly debits: $e'),
      );
    }
  }

  /// Helper method to determine which users a template applies to
  List<AppUser> _getTargetUsersForTemplate(MonthlyDebitTemplate template, List<AppUser> allUsers) {
    // If applies to all users, return all users
    if (template.applyToAllUsers) {
      return allUsers;
    }

    List<AppUser> targetUsers = [];

    // Add users by specific IDs
    if (template.specificUserIds.isNotEmpty) {
      for (final userId in template.specificUserIds) {
        try {
          final user = allUsers.firstWhere((u) => u.id == userId);
          if (!targetUsers.contains(user)) {
            targetUsers.add(user);
          }
        } catch (e) {
          log('Warning: User ID $userId not found in system');
        }
      }
    }

    // Add users by groups
    if (template.userGroups.isNotEmpty) {
      for (final user in allUsers) {
        // Check if user belongs to any of the required groups
        final userGroups = _getUserGroups(user);
        for (final requiredGroup in template.userGroups) {
          if (userGroups.contains(requiredGroup) && !targetUsers.contains(user)) {
            targetUsers.add(user);
            break; // User is already added, no need to check other groups
          }
        }
      }
    }

    return targetUsers;
  }

  /// Get user groups for a specific user
  /// You can implement this based on your business logic
  List<String> _getUserGroups(AppUser user) {
    // EXAMPLE IMPLEMENTATIONS - Choose one or create your own:
    
    // Option 1: Based on user ID hash (distributes users evenly)
    final userIdHash = user.id.hashCode.abs();
    final groupNumber = (userIdHash % 5) + 1; // Creates groups 1-5
    return ['group_$groupNumber'];

    // Option 2: Based on phone number last digit
    // final lastDigit = int.tryParse(user.phoneNumber.substring(user.phoneNumber.length - 1)) ?? 0;
    // final groupNumber = (lastDigit % 5) + 1;
    // return ['group_$groupNumber'];

    // Option 3: Based on user name first letter
    // final firstLetter = user.uniqueName.toLowerCase().substring(0, 1);
    // if (['a', 'b', 'c', 'd', 'e'].contains(firstLetter)) return ['group_1'];
    // if (['f', 'g', 'h', 'i', 'j'].contains(firstLetter)) return ['group_2'];
    // if (['k', 'l', 'm', 'n', 'o'].contains(firstLetter)) return ['group_3'];
    // if (['p', 'q', 'r', 's', 't'].contains(firstLetter)) return ['group_4'];
    // return ['group_5'];

    // Option 4: Store groups in user metadata (requires updating AppUser model)
    // return user.groups ?? ['default_group'];
  }

  /// Get users by group
  Future<List<AppUser>> getUsersByGroup(String groupName) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.where((user) => _getUserGroups(user).contains(groupName)).toList();
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get users by group: $e'),
      );
    }
  }

  /// Get all user groups and their user counts
  Future<Map<String, int>> getAllUserGroupStats() async {
    try {
      final allUsers = await getAllUsers();
      final Map<String, int> groupStats = {};

      for (final user in allUsers) {
        final userGroups = _getUserGroups(user);
        for (final group in userGroups) {
          groupStats[group] = (groupStats[group] ?? 0) + 1;
        }
      }

      return groupStats;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get user group stats: $e'),
      );
    }
  }

  /// Check if monthly debits should be executed (helper method for scheduling)
  Future<bool> shouldExecuteMonthlyDebits() async {
    try {
      final now = DateTime.now();
      
      // Only execute on the 1st of the month
      if (now.day != 1) return false;

      // Check if already executed this month
      final systemDoc = await _systemRef.doc('monthly_execution').get();
      if (!systemDoc.exists) return true;

      final lastExecution = (systemDoc.data() as Map<String, dynamic>)['lastExecution'] as Timestamp?;
      if (lastExecution == null) return true;

      final lastExecutionDate = lastExecution.toDate();
      // Return true if we haven't executed this month yet
      return !(lastExecutionDate.year == now.year && lastExecutionDate.month == now.month);
    } catch (e) {
      log('Error checking if monthly debits should be executed: $e');
      return false;
    }
  }

  /// Get monthly execution history
  Future<Map<String, dynamic>?> getMonthlyExecutionHistory() async {
    try {
      final doc = await _systemRef.doc('monthly_execution').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get monthly execution history: $e'),
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

  /// Get total owned money for a specific user (sum of all recordMoneyValue in owned items)
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

      log('Calculated debit totals for ${userTotals.length} users');
      return userTotals;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get all users total debit money: $e'),
      );
    }
  }

  /// Get total owned money for all users
  Future<Map<String, double>> getAllUsersTotalOwnedMoney() async {
    try {
      final usersSnapshot = await _usersRef.get();
      final Map<String, double> userTotals = {};

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final totalMoney = await getTotalOwnedMoney(userId);
        userTotals[userId] = totalMoney;
      }

      log('Calculated owned totals for ${userTotals.length} users');
      return userTotals;
    } catch (e) {
      throw FirebaseFailure.fromException(
        Exception('Failed to get all users total owned money: $e'),
      );
    }
  }

  /// Update all users' total debit and owned money (useful for data migration)
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
      final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
      _updateUserTotalsInTransaction(transaction, userId, debitItemsSnapshot, ownedItemsSnapshot);
    });
  }

  /// ENHANCED: Update user totals within a transaction for both debit and owned items
  void _updateUserTotalsInTransaction(
    Transaction transaction,
    String userId,
    QuerySnapshot debitItemsSnapshot,
    QuerySnapshot ownedItemsSnapshot, {
    String? excludeDebitItemId,
    String? excludeOwnedItemId,
    String? updateDebitItemId,
    String? updateOwnedItemId,
    Map<String, dynamic>? updatedDebitValues,
    Map<String, dynamic>? updatedOwnedValues,
    Map<String, dynamic>? newDebitItem,
    Map<String, dynamic>? newOwnedItem,
  }) {
    try {
      // Process debit items
      List<Map<String, dynamic>> processedDebitDocs = [];
      
      for (final doc in debitItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Skip if this is the item being deleted
        if (excludeDebitItemId != null && doc.id == excludeDebitItemId) {
          continue;
        }
        
        // Update values if this is the item being updated
        if (updateDebitItemId != null && doc.id == updateDebitItemId && updatedDebitValues != null) {
          final updatedData = Map<String, dynamic>.from(data);
          updatedData.addAll(updatedDebitValues);
          processedDebitDocs.add(updatedData);
        } else {
          processedDebitDocs.add(data);
        }
      }
      
      // Add new debit item if provided
      if (newDebitItem != null) {
        processedDebitDocs.add(newDebitItem);
      }

      // Process owned items
      List<Map<String, dynamic>> processedOwnedDocs = [];
      
      for (final doc in ownedItemsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Skip if this is the item being deleted
        if (excludeOwnedItemId != null && doc.id == excludeOwnedItemId) {
          continue;
        }
        
        // Update values if this is the item being updated
        if (updateOwnedItemId != null && doc.id == updateOwnedItemId && updatedOwnedValues != null) {
          final updatedData = Map<String, dynamic>.from(data);
          updatedData.addAll(updatedOwnedValues);
          processedOwnedDocs.add(updatedData);
        } else {
          processedOwnedDocs.add(data);
        }
      }
      
      // Add new owned item if provided
      if (newOwnedItem != null) {
        processedOwnedDocs.add(newOwnedItem);
      }
      
      // Calculate totals from processed documents
      final debitTotals = _calculateTotalsFromMaps(processedDebitDocs);
      final ownedTotals = _calculateOwnedTotalsFromMaps(processedOwnedDocs);

      transaction.update(_usersRef.doc(userId), {
        _totalDebitMoneyField: debitTotals.totalMoney,
        _totalMoneyOwedField: debitTotals.totalOwed,
        _totalOwnedMoneyField: ownedTotals.totalMoney,
      });

      log(
        'Updated user totals for $userId: debit=${debitTotals.totalMoney}, owed=${debitTotals.totalOwed}, owned=${ownedTotals.totalMoney}',
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

  /// ADDED: Helper method to calculate owned totals from processed maps
  ({double totalMoney}) _calculateOwnedTotalsFromMaps(
    List<Map<String, dynamic>> docs,
  ) {
    double totalMoney = 0.0;

    for (final data in docs) {
      final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
      totalMoney += money;
    }

    return (totalMoney: totalMoney);
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

  /// Get comprehensive user statistics (enhanced with owned items)
  Future<UserStatistics> getUserStatistics(String userId) async {
    try {
      _validateUserId(userId);

      final debitItemsSnapshot = await _debitItemsRef(userId).get();
      final ownedItemsSnapshot = await _ownedItemsRef(userId).get();
      final debitDocs = debitItemsSnapshot.docs;
      final ownedDocs = ownedItemsSnapshot.docs;

      final debitStatusCount = <String, int>{};
      final debitStatusTotal = <String, double>{};
      final ownedStatusCount = <String, int>{};
      final ownedStatusTotal = <String, double>{};
      
      final debitTotals = _calculateTotals(debitDocs);
      final ownedTotals = _calculateOwnedTotals(ownedDocs);

      // Process debit items
      for (final doc in debitDocs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = (data[_statusField] ?? 'unknown').toString().toLowerCase();
        final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();

        debitStatusCount[status] = (debitStatusCount[status] ?? 0) + 1;
        debitStatusTotal[status] = (debitStatusTotal[status] ?? 0.0) + money;
      }

      // Process owned items
      for (final doc in ownedDocs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = (data[_statusField] ?? 'unknown').toString().toLowerCase();
        final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();

        ownedStatusCount[status] = (ownedStatusCount[status] ?? 0) + 1;
        ownedStatusTotal[status] = (ownedStatusTotal[status] ?? 0.0) + money;
      }

      return UserStatistics(
        totalDebitItems: debitDocs.length,
        totalOwnedItems: ownedDocs.length,
        totalDebitMoney: debitTotals.totalMoney,
        totalMoneyOwed: debitTotals.totalOwed,
        totalOwnedMoney: ownedTotals.totalMoney,
        debitStatusCount: debitStatusCount,
        debitStatusTotal: debitStatusTotal,
        ownedStatusCount: ownedStatusCount,
        ownedStatusTotal: ownedStatusTotal,
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

  /// Calculate owned totals from documents
  ({double totalMoney}) _calculateOwnedTotals(
    List<QueryDocumentSnapshot> docs,
  ) {
    double totalMoney = 0.0; // Sum of ALL recordMoneyValue (totalOwnedMoney)

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final money = (data[_recordMoneyValueField] ?? 0.0).toDouble();
      totalMoney += money;
    }

    return (totalMoney: totalMoney);
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

  /// Map snapshot to owned items list
  List<OwnedItem> _mapSnapshotToOwnedItems(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return OwnedItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } catch (e) {
        log('Error mapping owned item document ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }

  /// Helper method to get month-year string for monthly debits
  String _getMonthYearString(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
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

  void _validateOwnedItemId(String ownedItemId) {
    if (ownedItemId.trim().isEmpty) {
      throw ArgumentError('Owned item ID cannot be empty');
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

  void _validateOwnedItemInput(
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

/// Enhanced data class for user statistics (now includes owned items)
class UserStatistics {
  final int totalDebitItems;
  final int totalOwnedItems;
  final double totalDebitMoney;
  final double totalMoneyOwed;
  final double totalOwnedMoney;
  final Map<String, int> debitStatusCount;
  final Map<String, double> debitStatusTotal;
  final Map<String, int> ownedStatusCount;
  final Map<String, double> ownedStatusTotal;

  const UserStatistics({
    required this.totalDebitItems,
    required this.totalOwnedItems,
    required this.totalDebitMoney,
    required this.totalMoneyOwed,
    required this.totalOwnedMoney,
    required this.debitStatusCount,
    required this.debitStatusTotal,
    required this.ownedStatusCount,
    required this.ownedStatusTotal,
  });

  // Legacy constructor for backward compatibility
  UserStatistics.legacy({
    required int totalItems,
    required double totalMoney,
    required double totalOwed,
    required Map<String, int> statusCount,
    required Map<String, double> statusTotal,
  }) : this(
    totalDebitItems: totalItems,
    totalOwnedItems: 0,
    totalDebitMoney: totalMoney,
    totalMoneyOwed: totalOwed,
    totalOwnedMoney: 0.0,
    debitStatusCount: statusCount,
    debitStatusTotal: statusTotal,
    ownedStatusCount: {},
    ownedStatusTotal: {},
  );

  Map<String, dynamic> toMap() {
    return {
      'totalDebitItems': totalDebitItems,
      'totalOwnedItems': totalOwnedItems,
      'totalDebitMoney': totalDebitMoney,
      'totalMoneyOwed': totalMoneyOwed,
      'totalOwnedMoney': totalOwnedMoney,
      'debitStatusCount': debitStatusCount,
      'debitStatusTotal': debitStatusTotal,
      'ownedStatusCount': ownedStatusCount,
      'ownedStatusTotal': ownedStatusTotal,
    };
  }

  @override
  String toString() {
    return 'UserStatistics(debitItems: $totalDebitItems, ownedItems: $totalOwnedItems, debitMoney: $totalDebitMoney, owed: $totalMoneyOwed, owned: $totalOwnedMoney)';
  }
}

/// Enhanced data class for monthly debit templates with user group support
class MonthlyDebitTemplate {
  final String id;
  final String recordName;
  final double recordMoneyValue;
  final String status;
  final bool isActive;
  final bool applyToAllUsers; // ✅ NEW: Whether this applies to all users
  final List<String> userGroups; // ✅ NEW: Which user groups this applies to
  final List<String> specificUserIds; // ✅ NEW: Specific user IDs this applies to
  final DateTime? createdAt;
  final Map<String, dynamic>? additionalFields;

  const MonthlyDebitTemplate({
    required this.id,
    required this.recordName,
    required this.recordMoneyValue,
    required this.status,
    required this.isActive,
    this.applyToAllUsers = true,
    this.userGroups = const [],
    this.specificUserIds = const [],
    this.createdAt,
    this.additionalFields,
  });

  factory MonthlyDebitTemplate.fromMap(Map<String, dynamic> map, String id) {
    return MonthlyDebitTemplate(
      id: id,
      recordName: map['recordName'] ?? '',
      recordMoneyValue: (map['recordMoneyValue'] ?? 0.0).toDouble(),
      status: map['status'] ?? '',
      isActive: map['isActive'] ?? true,
      applyToAllUsers: map['applyToAllUsers'] ?? true,
      userGroups: List<String>.from(map['userGroups'] ?? []),
      specificUserIds: List<String>.from(map['specificUserIds'] ?? []),
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      additionalFields: map['additionalFields'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recordName': recordName,
      'recordMoneyValue': recordMoneyValue,
      'status': status,
      'isActive': isActive,
      'applyToAllUsers': applyToAllUsers,
      'userGroups': userGroups,
      'specificUserIds': specificUserIds,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      if (additionalFields != null) 'additionalFields': additionalFields,
    };
  }

  /// Get target description for this template
  String get targetDescription {
    if (applyToAllUsers) return 'All Users';
    if (specificUserIds.isNotEmpty && userGroups.isNotEmpty) {
      return 'Groups: ${userGroups.join(', ')} + ${specificUserIds.length} specific users';
    }
    if (specificUserIds.isNotEmpty) return '${specificUserIds.length} specific users';
    if (userGroups.isNotEmpty) return 'Groups: ${userGroups.join(', ')}';
    return 'No targets defined';
  }

  @override
  String toString() {
    return 'MonthlyDebitTemplate(id: $id, recordName: $recordName, target: $targetDescription)';
  }
}
