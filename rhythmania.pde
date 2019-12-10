ArrayList<Nota> notas = new ArrayList<Nota>();
float velocidade;
int altura = window.innerHeight;
int largura = altura /2;
float velocidadeMinima = altura / 75;
float velocidadeMaxima = altura /45;
float aceleracao = velocidadeMaxima / 1500;
int tempoAteNovaNotaMax = 300;
float tempoAteNovaNotaMin = 100;
int pisoNovaNota = 50;
float passoNovaNota = 0.01;
int contadorLoop = 0;
int multiplier2 = 10;
int multiplier3 = 30;
int alturaNota = altura * 0.06;
float yBarra;
int streak = 0;
int comprimentoInicial = 50;
int comprimentoBarra = comprimentoInicial;
int barraMaxima = 100;
float pontos = 0;
boolean mostraPontos = true;
boolean start = true;
int contadorAtualizaPiso = 0;
int passoBarra = 1;
int passoVoltaBarra = 2;
int alturaBarra = 10;
int multiplier = 1;
int notes = 0;
boolean showBarra = false;
boolean pause = false;
float velocidadeBarraHit = 0.1;
String[] teclas = ['A','S','D','F',' ','J','K','L','Ç'];
String[] teclasMinusculas = ['a','s','d','f',' ','j','k','l','ç'];
boolean[] pressionado = [false,false,false,false,false,false,false,false];
int larguraNota = (largura / teclas.length);

void setup() {
  size(largura+8, altura); 
  yBarra = height - alturaNota * 3;
}

void draw() { 
  if (mostraPontos) { // FIM DE JOGO
		fill(0);
		textSize(15);
		if (start) {
			background(255);
			text("Use '"+teclas[0].toString()+"', '"+teclas[1].toString()+"', '"+teclas[2].toString()+"', '"+teclas[3].toString()+"', '"+teclas[4].toString()+"', '"+teclas[5].toString()+"', '"+teclas[6].toString()+"' and '"+teclas[7].toString()+"'",15,height/2);
			text("Press 'R' to Start",80,height/2+40);
		}
		else {
			background(255);
			text("Points: " + round(pontos),80,height/2);
			text("Notes: " + notes,80,height/2+40);
			text("('R' to restart)",80,height/2+80);
		}
		velocidade = 0;
		yBarra = height - alturaNota * 3;
		notas = new ArrayList<Nota>();
		comprimentoBarra = comprimentoInicial;
  } 
  else {
		if (!pause) {
			validaVelocidade();

			limpaTela();
			moveNotas();
			apagaNotasAntigas();

			if (contadorLoop >= (random(tempoAteNovaNotaMax-tempoAteNovaNotaMin)+tempoAteNovaNotaMin)) {
				adicionaNotas();
				contadorLoop = 0;
			}

			contadorLoop += velocidade;
			desenhaLinhas();
			desenhaBarraHit();
			desenhaBarra();
			desenhaLetras();
			desenhaBorda();
			desenhaNotas();
			desenhaInfos();

			if (velocidade >= velocidadeMaxima) {
				if (pisoNovaNota < tempoAteNovaNotaMin) 
					tempoAteNovaNotaMin -= passoNovaNota;
				else 
					yBarra -= velocidadeBarraHit;
			}
			if (yBarra > (height - alturaNota * 3)) yBarra = height - alturaNota * 3;
			if (yBarra < 0) comprimentoBarra = 0;
		}
  }
}

void desenhaLinhas() {
	fill(150);
	stroke(150);
	for (int i = 1; i < teclas.length; i++) {
		rect((float)(i * larguraNota+3),0,2,height);
	}
}

void desenhaBorda() {
	color c = (comprimentoBarra >= comprimentoInicial) ? color(0,int(((comprimentoBarra-comprimentoInicial)/(barraMaxima-comprimentoInicial))*255),0) : color(255-int((comprimentoBarra/(barraMaxima-50))*255),0,0);

  	fill(c);
  	stroke(c);

    rect(2,0,2,height);
    rect(width-4,0,2,height);

	fill(0);
  	stroke(0);

    rect(0,0,2,height);
    rect(width-6,0,2,height);
}

void desenhaLetras() {
	fill(0);
	int fontSize = floor(larguraNota/2);
	for (int i = 0; i < teclas.length; i++) {
		if (teclas[i] == ' ') {
			textSize(fontSize*0.6);
			text('space',larguraNota*i+fontSize*0.5, height - fontSize);
		}
		else {
			textSize(fontSize);
			text(teclas[i],larguraNota*i+fontSize*0.95, height - fontSize);
		} 
	}
}

void desenhaBarra() {
	if (showBarra) {
		fill(0);
		stroke(0);
		rect(0,height-alturaBarra,comprimentoBarra * (width/barraMaxima), 10);
	}
}

void desenhaInfos() {
	int alturaInfo = height*0.05;
	
	stroke(0);
	fill(0);
	rect(0,0,width,alturaInfo);
	
	textSize(alturaInfo/2);
	fill(255);
	text("Points: " + int(pontos), alturaInfo, alturaInfo*0.7);
	text("Multipier: " + multiplier + "x", width/2 - 20, alturaInfo*0.7);
	
	stroke(255);
	fill(0);
	rect(width * 0.75, alturaInfo*0.25, width*0.2, alturaInfo*0.5);
	fill(255);
	
	int maxBarra = 0;
	int minBarra = 0;
	
	if (multiplier == 1) maxBarra = multiplier2;
	else if (multiplier == 2) {
		minBarra = multiplier2;
		maxBarra = multiplier3;
	}
	else {
		minBarra = streak - 1;
		maxBarra = minBarra + 1;
	}
	
	rect(width * 0.75, alturaInfo*0.25, width*0.2 * ((streak - minBarra) / (maxBarra - minBarra)), alturaInfo*0.5);
}

void validaVelocidade() {
  if (velocidade < velocidadeMinima) velocidade = velocidadeMinima;
  else if (velocidade > velocidadeMaxima) velocidade = velocidadeMaxima;
}

void adicionaNotas() {
  int numeroDeNotas = int(random(multiplier)+1);
	
  ArrayList<Nota> notasAdicionar = new ArrayList<Nota>();

	notasAdicionar.add(new Nota());
	notas.add(new Nota());

  while (notasAdicionar.size() < numeroDeNotas) {
		boolean podeAdicionar = true;
		Nota notaNova = new Nota();
		for (Nota nota : notasAdicionar) {
			if (nota.indice == notaNova.indice) {
				podeAdicionar = false;
				break;
			}
		}
		
		if (podeAdicionar) {
			notasAdicionar.add(notaNova);
			notas.add(notaNova);
		}
  }
}

void moveNotas() {
  for (Nota nota : notas) {
    nota.altura += velocidade;
  }
}

void limpaTela() {
  background(255);
}

void desenhaBarraHit() {
  stroke(106, 254, 106);
  fill(106, 254, 106);
  rect(0, yBarra,width, alturaNota);
	stroke(150, 150, 150);
	fill(150, 150, 150);
	rect(0, yBarra,width, 10);

	for (int i = 0; i < pressionado.length; i++) {
		if (pressionado[i]) { 
			stroke(0, 191, 106);
  		fill(0, 191, 106);
			rect(i * ((width-8)/teclas.length)+4, yBarra,width/teclas.length, alturaNota);
			stroke(106, 254, 106);
  		fill(106, 254, 106);
			rect(i * ((width-8)/teclas.length)+4, yBarra-10,width/teclas.length, alturaNota);
		}
	}
}

void desenhaNotas() {
  for (Nota nota : notas) {
		strokeWeight(2);
    stroke(0);
		fill(blendColor(nota.cor,color(0),OVERLAY));
		rect(nota.indice * larguraNota+4, nota.altura+alturaNota-10, larguraNota, 10);
    fill(nota.cor);
    rect(nota.indice * larguraNota+4, nota.altura-10, larguraNota, alturaNota);
		strokeWeight(0);
  }
}

void apagaNotasAntigas() {
  for (int i = 0; i < notas.size(); i++) {
    if (notas.get(i).altura - alturaNota > height) {
      notas.remove(i);
      i--;
			aumentaAceleracao();
      perdePonto();
    }
  }
}

void perdePonto() {
  validaVelocidade();
  streak = 0;
  comprimentoBarra  -= passoVoltaBarra;
  validaBarra();
}

void validaBarra() {
  if(comprimentoBarra <= 0)  
  {
    mostraPontos = true;
  }
  else if (comprimentoBarra >= barraMaxima) comprimentoBarra = barraMaxima;
}

void keyPressed() {
	for (int i = 0; i < teclas.length; i++) {
		if (key == teclas[i] || key == teclasMinusculas[i]) {
    		pressionaNota(i);
  		}
	}
  
	if (key == 'r' || key == 'R') {
		if (!mostraPontos) pause = !pause;
		mostraPontos = false;
			start = false;
		pontos = 0;
			notes = 0;
	}
}

void keyReleased() {
	for (int i = 0; i < teclas.length; i++) {
		if (key == teclas[i] || key == teclasMinusculas[i]) {
    		pressionado[i] = false;
  		}
	}
}

void pressionaNota(int indice) {
	if (pressionado[indice] == false) {
		int indiceNota = retornaNotaNoIndice(indice);
	if (indiceNota != -1) pontuaNota(indiceNota);
	else perdePonto();
		pressionado[indice] = true;
	}
}

void pontuaNota(int indiceNota) {
  notas.remove(indiceNota);
	notes++;
	aumentaAceleracao();
  validaVelocidade();
  streak++;
  comprimentoBarra+= passoBarra * multiplier;
  pontos += velocidade * multiplier;  
  validaBarra();
	
	if (streak < multiplier2) {
    multiplier = 1;
  }
  else if (streak < multiplier3) {
    multiplier = 2;
  }
	else {
    multiplier = 3;
  }
}

void aumentaAceleracao() {
	 velocidade += aceleracao * 0.8;
}

int retornaNotaNoIndice(int indice) {
  for (int i = 0; i < notas.size(); i++) {
    if (notas.get(i).altura > yBarra - (alturaNota + 1) && notas.get(i).altura < yBarra + (alturaNota * 2) + 1 && notas.get(i).indice == indice) {
      return i;
    }
  }
  return -1;
}

class Nota {
  color cor;
  int indice;
  int altura;
	
  Nota() {
    int numeroAleatorio = int(random(teclas.length));
    
    indice = numeroAleatorio;
    altura = 0;

    switch (numeroAleatorio) {
		case 0: 
			cor = color(120, 197, 213);
			break;
		case 1: 
        	cor = color(69, 155, 168);
			break;
		case 2: 
			cor = color(121, 194, 104);
			break;
		case 3: 
			cor = color(197, 215, 71);
			break;
		case 4: 
			cor = color(100);
			break;
		case 5: 
			cor = color(245, 214, 61);
			break;
		case 6: 
			cor = color(241, 140, 50);
			break;
		case 7:	
			cor = color(232, 104, 161);
			break;
		case 8: 
			cor = color(191, 99, 166);
			break;
    }
  }
}