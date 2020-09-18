# Clasificacion-Latidos-Tesis

Se presenta el desarrollo de un sistema que permite a dispositivos portátiles de registro de electrocardiogramas (holter) pasar de un esquema totalmente 
de adquisición y almacenamiento/transmisión, a un esquema más eficiente e inteligente de adquisición y procesamiento local, para determinar si es necesario 
realizar la transmisión o almacenamiento de los datos. 

El algoritmo de procesamiento diseñado, realiza el filtrado y la segmentación de la señal basado en transformaciones sencillas y la detección de picos. 
Luego, los latidos son descompuestos mediante el Análisis de Componentes Independientes, resultando en un conjunto de 5 características. Finalmente, los 
latidos son clasificados mediante una estrategia de inteligencia artificial denominada Máquina de Vectores de Soportes de una clase.

La clasificación obtenida es binaria, es decir que los latidos se clasifican en normales (sanos o patológicos dependiendo del paciente) y anormales. 
Esto no permite especificar las patologías, pero brinda la importante ventaja de no requerir grandes bases de datos.
El algoritmo propuesto fue implementado en Matlab® y probado con aproximadamente 27000 latidos (20500 normales y 6500 anormales) extraídos de la base de 
datos de arritmias del MIT-BIH, obteniendo un ahorro medio de almacenamiento/transmisión de datos del 64%, con límites superior e inferior 
del 85% y 48%, respectivamente, y una precisión frente a los latidos anormales de un 99%.
