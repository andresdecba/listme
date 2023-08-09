part of 'counter_cubit.dart';

class Counter extends Equatable {
  const Counter({
    required this.counter,
    required this.transactions,
  });

  final int counter;
  final int transactions;

  Counter copiWith({required int counterValue, int? transactionsValue}) {
    return Counter(
      counter: counterValue,
      transactions: transactionsValue ?? transactions,
    );
  }

  @override
  List<Object> get props => [counter, transactions];
}
