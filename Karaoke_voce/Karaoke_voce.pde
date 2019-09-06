import voce.*;

color exito=#76b852; // color de fondo en un acierto.
color fallo=#ee4f4f; // color de fondo en un fallo.
color boton1=#00aaff; //color primario del botón.
color boton2=#6cbc35; //color secundario del boton.
color background=#f4f7f9; // color fondo por default.
color blanco=#f4f7f9; //color blanco 
color texto=#323b43; //color texto por default.
boolean inicio=false, instrucciones=false; //inició el juego?
Button botonInicio, botonInstrucciones, botonVolver, botonSiguiente; //botones. 
Prueba pregunta, result, confirm; //modela una pregunta y el resultado de la prueba.
int aciertos; //aciertos
int intentos=1; // intentos
String grabacion=""; //guarda la palabra grabada
boolean good=false; //true si la palabra es pronunciada correctamente, false de lo contrario
String[][] preguntas=new String[2][11];
{
  // números
  preguntas[0][0]="zero";
  preguntas[0][1]="one";
  preguntas[0][2]="two";
  preguntas[0][3]="three";
  preguntas[0][4]="four";
  preguntas[0][5]="five";
  preguntas[0][6]="six";
  preguntas[0][7]="seven";
  preguntas[0][8]="eight";
  preguntas[0][9]="nine";
  preguntas[0][10]="ten";
  //colores
  preguntas[1][0]="yellow";
  preguntas[1][1]="pink";
  preguntas[1][2]="purple";
  preguntas[1][3]="blue";
  preguntas[1][4]="orange";
  preguntas[1][5]="green";
  preguntas[1][6]="white";
  preguntas[1][7]="grey";
  preguntas[1][8]="red";
  preguntas[1][9]="black";
  preguntas[1][10]="golden";
}


void setup() { 

  size(1000, 500); 
  botonInicio= new Button(int(width/2-textWidth(" iniciar Karaoke "))-38, height/2-80, 60, 32, " Iniciar Karaoke ", boton1, boton2 );
  botonInstrucciones=new Button(int(width/2-textWidth(" instrucciones "))-33, height/2, 60, 32, " Instrucciones ", boton1, boton2 );
  botonVolver=new Button(40, height-100, 40, 20, " Prev ", boton1, boton2 );
  botonSiguiente= new Button(int(width-textWidth(" Next "))-70, height-100, 40, 20, " Next ", boton1, boton2 );
  voce.SpeechInterface.init("lib/voce/library", false, true, 
    "lib/voce/library/gram", "digits");

  System.out.println("This is a speech recognition test. "
    + "Say ON or OFF in the microphone");
}

void draw() {
  background(background);
  if (!inicio&&intentos!=10&&!instrucciones) {
    botonInicio.draw();
    botonInstrucciones.draw();
  }

  if (inicio) {
    pregunta.draw();
    botonVolver.draw();
    botonSiguiente.draw();
    text("", 500, 300);

    while (voce.SpeechInterface.getRecognizerQueueSize() > 0)
    {
      grabacion = voce.SpeechInterface.popRecognizedString();
      if (!good) {
        if (esCorrecta(grabacion, pregunta.label)) {
          aciertos++;
          changeBackground(exito);
          pregunta.changeColor(255);
          good=true;
        } else {
          changeBackground(fallo);
          //pregunta.changeColor(255);
        }
      }
      System.out.println("Se te escuchó: " + grabacion +". y se esperaba: "+ pregunta.label);
    }
    textSize(20);
    fill(0);
    text("Hits: " + aciertos+"/10", 800, 30);
    if (!grabacion.equals("")&&!good) {
      textAlign(CENTER);
      text("te escuché decir: " +grabacion, 500, 300);
    }


    if (intentos==10) {
      inicio=false;
    }
  } else if (instrucciones) {
    botonVolver.draw();
    textAlign(LEFT);
    fill(boton2);
    textSize(30);
    text("!Hola, este es un karaoke que te ayuda a aprender inglés¡" ,50,100);
    textSize(20);
    text("1. Dale 'Iniciar Karaoke'.",50,180);
    text("2. pronuncia claramente la palabra que vez en pantalla.",50,210);
    text("2. si tu pronunciación es correcta veras verde, si nó, será  rojo :c.",50,240);
    text("3. Da click en 'Next' cuando hayas pronunciado correctamente o quieras probar con otra palabra.",50,270);
    text("4. !Eso es todo¡, ahora ya puedes aprender ingles divirtiendote.",50,300);


    
  } else if (intentos==10) {
    textSize(20);
    String resultado= "Ace";
    color colorin=0;
    if (aciertos<4) {
      colorin=fallo;  //ROJO
      resultado= "Bad";
    } else if (aciertos>=4&&intentos<6) {
      colorin=boton1; //AZUL
      resultado = "Nice";
    } else if (aciertos>=6&&aciertos<9)
    {
      colorin=exito; //VERDE
      resultado = "Awesome";
    } else if ( aciertos>=9 ) {
      colorin=#ffdd00; //Amarillo oro
      resultado = "Excellent";
    }
    result=new Prueba(resultado, 60, 500, 250 );
    result.changeColor(colorin);   
    confirm=new Prueba(aciertos+"/10", 60, 500, 300 );
    confirm.changeColor(colorin);
    result.draw();
    confirm.draw();
    botonSiguiente.draw();
  }
}    


void pantallaFinal() {
}
void changeBackground(color col) {
  this.background=col;
}
/*
  si la prounciación de la palabra es correcta retorna true, si no retorna false.
 */
boolean esCorrecta(String pregunta, String pronunciacion) {
  if (pregunta.equals(pronunciacion)) {
    return true;
  } else
    return false;
}
/*
  Escoge una nueva pregunta al azar de la matríz de preguntas
 */
void escogerPregunta() {
  int tipo= (int) random(2);
  int item= (int)random(10);
  pregunta.changeLabel(preguntas[tipo][item]);
}


void mousePressed() {
  if (botonInicio.over()) {
    println("Se inicia el juego");
    inicio=true;
    botonVolver.changeLabel("Retry");
    pregunta= new Prueba("", 60, 500, 250);
    escogerPregunta();
  } else if (botonInstrucciones.over()) {
    println("Instrucciones");
    instrucciones=true;
  } else if (botonVolver.over()) {

    if (instrucciones==true) {
      println("prev de instrucciones");
      instrucciones=false;
    } else {
      changeBackground(blanco);
    }
  } else if (botonSiguiente.over()) {
    if (intentos==10) {
      intentos=0;
      aciertos=0;
    } else {
      grabacion="";
      good=false;
      escogerPregunta();
      changeBackground(blanco);
      pregunta.changeColor(0);
      intentos++;
    }
  }
}


/*
modela una pregunta
 */

class Prueba {
  String label;
  int size, x, y;
  color col=0;

  Prueba(String label, int size, int x, int y) {
    this.label = label;
    this.size=size;
    this.x=x;
    this.y=y;
  }
  void draw() {
    fill(col);
    textAlign(CENTER);
    textSize(size);
    text(label, x, y);
  }
  void changeColor(color col) {
    this.col=col;
  }
  void changeLabel( String label) {
    this.label=label;
  }
}

/*
modela un botón
 */
class Button {
  int x, y, alto, texto;
  String label ;
  color relleno, resaltado;
  Button(int x, int y, int alto, int texto, String label, color relleno, color resaltado) {
    this.x = x;
    this.y = y;
    this.alto=alto;
    this.texto= texto;
    this.label = label;
    this.relleno = relleno;
    this.resaltado = resaltado;
  }
  void draw() {
    textSize(texto);

    fill(relleno);
    if (over()) {
      fill(resaltado);
    }
    rect(x, y, textWidth(label)+5, alto, 6);
    fill(255);
    textAlign(LEFT);
    text(label, x, y +alto -2*alto/7);
  }

  void changeLabel(String label) {
    this.label=label;
  }
  boolean over() {
    if (mouseX >= x && mouseY >= y && mouseX <= x + textWidth(label) && mouseY <= y + alto) {
      return true;
    }
    return false;
  }
}
