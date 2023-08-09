// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:listme/borrar/cubit_ejemplo/cubit/counter_cubit.dart';

// class CounterScreen extends StatelessWidget {
//   const CounterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // PRIMERO: envolver en 'BlocProvider' al nivel que necesitemos el alcance del cubit
//     return BlocProvider(
//       create: (context) => CounterCubit(),
//       child: const _Counter(),
//     );
//   }
// }

// // SEGUNDO: metodos de actualización
// class _Counter extends StatelessWidget {
//   const _Counter();

//   @override
//   Widget build(BuildContext context) {
//     // metodo UNO
//     final counterState = context.watch<CounterCubit>().state;

//     // '.read()' acceder a los metodos del cubit
//     final counterCubit = context.read<CounterCubit>();

//     return Scaffold(
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           FloatingActionButton(
//             onPressed: () => counterCubit.resetCounter(),
//             child: const Icon(Icons.restart_alt),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           FloatingActionButton(
//             onPressed: () => counterCubit.incrementCounter(1),
//             child: const Icon(Icons.add),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           FloatingActionButton(
//             onPressed: () => context.read<CounterCubit>().decrementCounter(1),
//             child: const Icon(Icons.remove),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // METODO UNO para escuchar al estado similiar a riverpod
//             // no es tan eficiente como el método tres por que cuando se lo llama,
//             // evalúa todos a todos los widgets dentro del build() para saber cual actualizar
//             // no usar '.watch()' adenro de funciones
//             Text(
//               'Count con .watch(): ${counterState.counter}',
//               style: const TextStyle(fontSize: 25),
//             ),

//             // METODO DOS con 'BlocBuilder' similiar a GetView de getX
//             // usado para un widget que necesita ser actualizado en varios lugares
//             BlocBuilder<CounterCubit, Counter>(
//               builder: (context, state) {
//                 return Text(
//                   'Count con BlocBuilder: ${state.counter}',
//                   style: const TextStyle(fontSize: 25),
//                 );
//               },
//             ),

//             // METODO TRES usando 'context.select()'
//             // usado para actualizar "un sólo valor" por lo tanto es más eficiente que el método uno
//             context.select((CounterCubit value) {
//               return Text(
//                 'count con .select(): ${value.state.counter}',
//                 style: const TextStyle(fontSize: 25),
//               );
//             }),

//             // copia de TRES
//             context.select((CounterCubit value) {
//               return Text(
//                 'Transactions: ${value.state.transactions}',
//                 style: const TextStyle(fontSize: 15),
//               );
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
