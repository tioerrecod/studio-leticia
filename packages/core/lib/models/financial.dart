class Payment {
  final String id;
  final String appointmentId;
  final String customerId;
  final String method;
  final double amount;
  final int installments;
  final String? gateway;
  final String? gatewayPaymentId;
  final String? gatewayStatus;
  final String status;
  final DateTime? paidAt;
  final DateTime? refundedAt;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.appointmentId,
    required this.customerId,
    required this.method,
    required this.amount,
    this.installments = 1,
    this.gateway,
    this.gatewayPaymentId,
    this.gatewayStatus,
    this.status = 'pending',
    this.paidAt,
    this.refundedAt,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as String,
    appointmentId: json['appointment_id'] as String,
    customerId: json['customer_id'] as String,
    method: json['method'] as String,
    amount: (json['amount'] as num).toDouble(),
    installments: json['installments'] as int? ?? 1,
    gateway: json['gateway'] as String?,
    gatewayPaymentId: json['gateway_payment_id'] as String?,
    gatewayStatus: json['gateway_status'] as String?,
    status: json['status'] as String? ?? 'pending',
    paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
    refundedAt: json['refunded_at'] != null ? DateTime.parse(json['refunded_at'] as String) : null,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'appointment_id': appointmentId,
    'customer_id': customerId,
    'method': method,
    'amount': amount,
    'installments': installments,
    'gateway': gateway,
    'gateway_payment_id': gatewayPaymentId,
    'gateway_status': gatewayStatus,
    'status': status,
    'paid_at': paidAt?.toIso8601String(),
    'refunded_at': refundedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  String get formattedAmount => 'R\$ ${amount.toStringAsFixed(2)}';
  String get methodLabel {
    switch (method) {
      case 'pix': return 'PIX';
      case 'credit_card': return 'Cartão de Crédito';
      case 'debit_card': return 'Cartão de Débito';
      case 'cash': return 'Dinheiro';
      case 'ticket': return 'Boleto';
      default: return method;
    }
  }
}

class FinancialTransaction {
  final String id;
  final String type;
  final String category;
  final double amount;
  final String? description;
  final String? referenceId;
  final String? referenceType;
  final String? paymentMethod;
  final String status;
  final bool reconciled;
  final DateTime createdAt;

  const FinancialTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    this.referenceId,
    this.referenceType,
    this.paymentMethod,
    this.status = 'pending',
    this.reconciled = false,
    required this.createdAt,
  });

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) => FinancialTransaction(
    id: json['id'] as String,
    type: json['type'] as String,
    category: json['category'] as String,
    amount: (json['amount'] as num).toDouble(),
    description: json['description'] as String?,
    referenceId: json['reference_id'] as String?,
    referenceType: json['reference_type'] as String?,
    paymentMethod: json['payment_method'] as String?,
    status: json['status'] as String? ?? 'pending',
    reconciled: json['reconciled'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'category': category,
    'amount': amount,
    'description': description,
    'reference_id': referenceId,
    'reference_type': referenceType,
    'payment_method': paymentMethod,
    'status': status,
    'reconciled': reconciled,
    'created_at': createdAt.toIso8601String(),
  };

  String get formattedAmount => 'R\$ ${amount.toStringAsFixed(2)}';
  bool get isRevenue => type == 'revenue';
  bool get isExpense => type == 'expense';
  bool get isCommission => type == 'commission';
}

class CommissionEntry {
  final String id;
  final String professionalId;
  final String appointmentId;
  final double amount;
  final double percentage;
  final String status;
  final DateTime? paidAt;
  final String? paidBy;
  final DateTime createdAt;

  const CommissionEntry({
    required this.id,
    required this.professionalId,
    required this.appointmentId,
    required this.amount,
    required this.percentage,
    this.status = 'pending',
    this.paidAt,
    this.paidBy,
    required this.createdAt,
  });

  factory CommissionEntry.fromJson(Map<String, dynamic> json) => CommissionEntry(
    id: json['id'] as String,
    professionalId: json['professional_id'] as String,
    appointmentId: json['appointment_id'] as String,
    amount: (json['amount'] as num).toDouble(),
    percentage: (json['percentage'] as num).toDouble(),
    status: json['status'] as String? ?? 'pending',
    paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
    paidBy: json['paid_by'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'professional_id': professionalId,
    'appointment_id': appointmentId,
    'amount': amount,
    'percentage': percentage,
    'status': status,
    'paid_at': paidAt?.toIso8601String(),
    'paid_by': paidBy,
    'created_at': createdAt.toIso8601String(),
  };

  String get formattedAmount => 'R\$ ${amount.toStringAsFixed(2)}';
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isPaid => status == 'paid';
}

class CashRegister {
  final String id;
  final String openedBy;
  final String? closedBy;
  final DateTime openedAt;
  final DateTime? closedAt;
  final double initialBalance;
  final double? expectedBalance;
  final double? actualBalance;
  final double? difference;
  final String? notes;
  final String status;

  const CashRegister({
    required this.id,
    required this.openedBy,
    this.closedBy,
    required this.openedAt,
    this.closedAt,
    required this.initialBalance,
    this.expectedBalance,
    this.actualBalance,
    this.difference,
    this.notes,
    this.status = 'open',
  });

  factory CashRegister.fromJson(Map<String, dynamic> json) => CashRegister(
    id: json['id'] as String,
    openedBy: json['opened_by'] as String,
    closedBy: json['closed_by'] as String?,
    openedAt: DateTime.parse(json['opened_at'] as String),
    closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
    initialBalance: (json['initial_balance'] as num).toDouble(),
    expectedBalance: (json['expected_balance'] as num?)?.toDouble(),
    actualBalance: (json['actual_balance'] as num?)?.toDouble(),
    difference: (json['difference'] as num?)?.toDouble(),
    notes: json['notes'] as String?,
    status: json['status'] as String? ?? 'open',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'opened_by': openedBy,
    'closed_by': closedBy,
    'opened_at': openedAt.toIso8601String(),
    'closed_at': closedAt?.toIso8601String(),
    'initial_balance': initialBalance,
    'expected_balance': expectedBalance,
    'actual_balance': actualBalance,
    'difference': difference,
    'notes': notes,
    'status': status,
  };

  String get formattedInitialBalance => 'R\$ ${initialBalance.toStringAsFixed(2)}';
  bool get isOpen => status == 'open';
  bool get isClosed => status == 'closed';
}

class FinancialSummary {
  final double todayRevenue;
  final double pixToday;
  final double cardToday;
  final double cashToday;
  final double todayExpenses;
  final double pendingCommissions;

  const FinancialSummary({
    required this.todayRevenue,
    required this.pixToday,
    required this.cardToday,
    required this.cashToday,
    required this.todayExpenses,
    required this.pendingCommissions,
  });

  String get formattedTodayRevenue => 'R\$ ${todayRevenue.toStringAsFixed(2)}';
  String get formattedPendingCommissions => 'R\$ ${pendingCommissions.toStringAsFixed(2)}';
  double get todayProfit => todayRevenue - todayExpenses;
}