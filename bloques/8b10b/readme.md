# Información de los Bloques 8b10b
Para _encoding_ y _decoding_ 8b/10b

## Porque

>Esta codificación permite:
> - Sincronizar los relojes del emisor-receptor continuamente (mínimo cada 5 bits transmitidos).
> - Permitir la transmisión de cadenas especiales de control (patrones coma).
> - Facilitar la detección y corrección de errores.

## Que hace

En brevedad el _encoding_ 8b10b transforma una cadena de
8 bits en una de 10 bits, esto antes de enviarlo al receptor
que a su vez realiza el _decoding_, de 10 bits a 8 bits.
