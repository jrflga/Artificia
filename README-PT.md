# Artificia

Um simples experimento de pathfinding A* usando o framework LÖVE da linguagem Lua.

Talvez se torne um jogo em algum ponto no futuro. Quem sabe.

![Screenshot](http://i.avll.ml/00009.png)

## Como executar

Requer [LÖVE 2D](http://love2d.org/) v0.10.1 ou maior.

Depois da instalação / download da versão portátil, arraste a pasta "Artificia"
para love.exe, e tudo deve correr bem.

![GIF explicativo](http://i.avll.ml/00007.gif)

Pressione as seguintes teclas para pintar as diferentes tiles:

```1 - Clear
    Limpa a tile clicada

2 - Parece
    Adiciona uma parede à tile clicada

3 - Água
    Adiciona água à tile clicada

4 - Ponto A
    Define o ponto inicial

5 - Ponto B
    Define o ponto final

6 - Executar
    Executa o algoritmo de pathfinding```

## Problemas conhecidos

No momento, esses são os problemas conhecidos:

* Tiles de água não são diferentes de tiles normais;
* A definição de Ponto A e B ainda bugs;
* Paredes nem sempre são respeitadas pelo algoritmo;
* Ponto A e B não podem estar na mesma linha ou coluna, ou o algoritmo não funciona;
* O aplicativo fecha às vezes quando Ponto A ou B é definido para um canto do mapa;
* É comum que o aplicativo feche quando o ponto A ou B é definido após um redimensionamento do mapa;

Por favor, tenha paciência. Esta é uma versão de teste do algoritmo.

<hr/>

<p align="center">
<a title="Fabieli Helena" target="_blank" href="http://github.com/FabieliHelena">
    <img src="https://avatars0.githubusercontent.com/u/11227629?s=50"/>
</a>&nbsp;&nbsp;
<a title="João Ricardo" target="_blank" href="http://github.com/JRFLGA">
    <img src="https://avatars0.githubusercontent.com/u/3507471?s=50"/>
</a>&nbsp;&nbsp;
<a title="Matheus Avellar" target="_blank" href="http://github.com/MatheusAvellar">
    <img src="https://avatars0.githubusercontent.com/u/1719996?s=50"/>
</a>&nbsp;&nbsp;
<a title="Milena Crivella" target="_blank" href="http://github.com/MilenaCrivella">
    <img src="https://avatars0.githubusercontent.com/u/9369529?s=50"/>
</a>&nbsp;&nbsp;
<a title="Thiago do Prado" target="_blank" href="http://github.com/PradoTPS">
    <img src="https://avatars0.githubusercontent.com/u/11035000?s=50"/>
</a>&nbsp;&nbsp;
<a title="Thiago Torres" target="_blank" href="http://github.com/ThiagoZx">
    <img src="https://avatars0.githubusercontent.com/u/11080794?s=50"/>
</a>
</p>
