// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'counter_state.dart';

// // extender de Cubit con el tipado de la entidad que queremos actualizar
// class CounterCubit extends Cubit<Counter> {
//   // el contructor sirve para asignarle un valor inicial al estago
//   CounterCubit() : super(const Counter(counter: 5, transactions: 0));

//   // crear funciones para manejar la lógica
//   void incrementCounter(int counterValue) {
//     // para actualizar el estado llamar a la funcion 'emit'
//     emit(state.copiWith(
//       counterValue: state.counter + counterValue,
//       transactionsValue: state.transactions + 1,
//     ));
//   }

//   void decrementCounter(int counterValue) {
//     emit(state.copiWith(
//       counterValue: state.counter - counterValue,
//       transactionsValue: state.transactions + 1,
//     ));
//   }

//   void resetCounter() {
//     emit(state.copiWith(
//       counterValue: 0,
//     ));
//   }
// }
