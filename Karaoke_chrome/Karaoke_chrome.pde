import websockets.*;

WebsocketServer socket;

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
String[][] preguntas=new String[4][11];
{
  // números
  preguntas[0][0]="Zero";
  preguntas[0][1]="One";
  preguntas[0][2]="Two";
  preguntas[0][3]="Three";
  preguntas[0][4]="Four";
  preguntas[0][5]="Five";
  preguntas[0][6]="Six";
  preguntas[0][7]="Seven";
  preguntas[0][8]="Eight";
  preguntas[0][9]="Nine";
  preguntas[0][10]="Ten";
  //colores
  preguntas[1][0]="Yellow";
  preguntas[1][1]="Pink";
  preguntas[1][2]="Purple";
  preguntas[1][3]="Blue";
  preguntas[1][4]="Orange";
  preguntas[1][5]="Green";
  preguntas[1][6]="White";
  preguntas[1][7]="Grey";
  preguntas[1][8]="Red";
  preguntas[1][9]="Black";
  preguntas[1][10]="Golden";
  //animales
  preguntas[2][0]="Monkey";
  preguntas[2][1]="Toucan";
  preguntas[2][2]="Parrot";
  preguntas[2][3]="Tiger";
  preguntas[2][4]="Lion";
  preguntas[2][5]="Gorilla";
  preguntas[2][6]="Cheetah";
  preguntas[2][7]="Crocodile";
  preguntas[2][8]="Cat";
  preguntas[2][9]="Dog";
  preguntas[2][10]="Horse";
    //frutas
  preguntas[3][0]="Apple";
  preguntas[3][1]="Banana";
  preguntas[3][2]="Pear";
  preguntas[3][3]="Lemon";
  preguntas[3][4]="Strawberry";
  preguntas[3][5]="Pineapple";
  preguntas[3][6]="Grape";
  preguntas[3][7]="Cherry";
  preguntas[3][8]="Blueberry";
  preguntas[3][9]="Avocado";
  preguntas[3][10]="Coconut";
}


void setup() { 

  size(1000, 500); 
  socket = new WebsocketServer(this, 1337, "/websocket");
  botonInicio= new Button(int(width/2-textWidth(" iniciar Karaoke "))-38, height/2-80, 60, 32, " Iniciar Karaoke ", boton1, boton2 );
  botonInstrucciones=new Button(int(width/2-textWidth(" instrucciones "))-33, height/2, 60, 32, " Instrucciones ", boton1, boton2 );
  botonVolver=new Button(40, height-100, 40, 20, " Prev ", boton1, boton2 );
  botonSiguiente= new Button(int(width-textWidth(" Next "))-70, height-100, 40, 20, " Next ", boton1, boton2 );
}

void webSocketServerEvent(String msg){
 grabacion=msg;
 grabacion=grabacion.replace(" ","");
 println(msg);
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

      if (!good) {
        if (esCorrecta(grabacion, pregunta.label)) {
          aciertos++;
          changeBackground(exito);
          pregunta.changeColor(255);
          good=true;
        } else if(!grabacion.equals("")){
          changeBackground(fallo);
          //pregunta.changeColor(255);
        }
      }
      System.out.println("Se te escuchó:" + grabacion +". y se esperaba: "+ pregunta.label);
          System.out.println(grabacion.equalsIgnoreCase(pregunta.label)+"tam g: "+grabacion.length()+" tam label: "+pregunta.label.length() );

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
    text("1. Abre 'Karaoke.html' y proporciona permisos de micrófono.",50,150);
    text("2. Dale 'Iniciar Karaoke'.",50,180);
    text("3. pronuncia claramente la palabra que vez en pantalla.",50,210);
    text("4. si tu pronunciación es correcta veras verde, si nó, será  rojo :c.",50,240);
    text("5. Da click en 'Next' cuando hayas pronunciado correctamente o quieras probar con otra palabra.",50,270);
    text("6. !Eso es todo¡, ahora ya puedes aprender ingles divirtiendote.",50,300);


    
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
  if (pregunta.equalsIgnoreCase(pronunciacion)) {
    return true;
  } else
    return false;
}
/*
  Escoge una nueva pregunta al azar de la matríz de preguntas
 */
void escogerPregunta() {
  int tipo= (int) random(4);
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
      grabacion="";
      changeBackground(blanco);
      fill(0);
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
