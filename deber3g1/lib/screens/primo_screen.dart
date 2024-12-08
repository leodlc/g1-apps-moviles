import 'package:flutter/material.dart';
import '../logic/primo_logic.dart';

class PrimeScreen extends StatelessWidget {
  final int step;

  PrimeScreen({required this.step});

  @override
  Widget build(BuildContext context) {
    final List<int> primes = findPrimes(3, 32767, step);

    return Scaffold(
      appBar: AppBar(
        title: Text('Números Primos entre 3 y 32767'),
        backgroundColor: const Color.fromARGB(255, 243, 131, 181),  
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: primes.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,  
                borderRadius: BorderRadius.circular(10.0),  
                border: Border.all(color: Colors.blue, width: 1.0),  
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,  
                    color: const Color.fromARGB(255, 255, 218, 162),  
                  ),
                  SizedBox(width: 12.0),  
                  Text(
                    primes[index].toString(),
                    style: TextStyle(
                      fontSize: 18.0,  
                      fontWeight: FontWeight.bold, 
                      color: Colors.black,  
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
