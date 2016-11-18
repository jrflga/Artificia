# Artificia

<a href="./README-PT.md">Versão em português</a>

A simple A* pathfinding experiment using Lua's LÖVE framework.

Might become a game at some point in the future. Who knows.

![Screenshot](http://i.avll.ml/00009.png)

## How to run

This requires [LÖVE 2D](http://love2d.org/) v0.10.1 or higher.

After the installation / unzipping of the portable version, just drag the "Artificia"
folder to love.exe, and everything should run smoothly.

![Explanation GIF](http://i.avll.ml/00007.gif)

Press the following numbers on the keyboard to paint different tiles:

```
1 - Clear
    Clears the clicked tile

2 - Wall
    Adds a wall to the clicked tile

3 - Water
    Adds water to the clicked tile

4 - Point A
    Sets the start point

5 - Point B
    Sets the end point

6 - Run
    Runs the pathfinding algorithm
```

## Known issues

As of right now, these are the known issues:

* Water tiles aren't any different than regular tiles;
* Point A and B setting is buggy;
* Walls are not always respected by the algorithm;
* Point A and B cannot be on the same row or column, or the algorithm doesn't work;
* The application crashes sometimes when Point A or B is set to the map's corner;
* The application might crash when point A or B is set after a map resize;

Please bear with us. This is a very early test stage of the algorithm.

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
