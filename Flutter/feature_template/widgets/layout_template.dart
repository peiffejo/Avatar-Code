import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'drag_target_tile.dart';

class LayoutTemplate{

  //Problems with Draggable-hover-color-change, needs for every 'Widget size' new instance
  Widget gridTile(int cross, int main, Widget size) {
    return StaggeredGridTile.count(
      crossAxisCellCount: cross,
      mainAxisCellCount: main,
      child: size,
      );
  }

   late List<Widget> layoutTemplate = [
    //First Layout
    StaggeredGrid.count(
      crossAxisCount: 20,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
        gridTile(5, 5,DragTargetTile().dragTargetSmallTile),
        gridTile(5, 5,DragTargetTile().dragTargetSmallTile),
        gridTile(10, 5,DragTargetTile().dragTargetMediumTile),
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
      ],
    ),
    //Second Layout
    StaggeredGrid.count(
      crossAxisCount: 20,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
        gridTile(5, 5, DragTargetTile().dragTargetSmallTile),
        gridTile(5, 5, DragTargetTile().dragTargetSmallTile),
        gridTile(5, 5, DragTargetTile().dragTargetSmallTile),
        gridTile(5, 5, DragTargetTile().dragTargetSmallTile),
        gridTile(10, 5, DragTargetTile().dragTargetSmallTile),
        gridTile(10, 5, DragTargetTile().dragTargetSmallTile),
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
        gridTile(10,10,DragTargetTile().dragTargetBigTile),
      ],
    ),
    //Third Layout
    StaggeredGrid.count(
      crossAxisCount: 20,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 10,
          child: DragTargetTile().dragTargetBigTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),

        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 10,
          child: DragTargetTile().dragTargetBigTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 10,
          child: DragTargetTile().dragTargetBigTile,
        ),
      ],
    ),
    //Fourth Layout
    StaggeredGrid.count(
      crossAxisCount: 20,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 10,
          child: DragTargetTile().dragTargetBigTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),

        StaggeredGridTile.count(
          crossAxisCellCount: 5,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 5,
          child: DragTargetTile().dragTargetSmallTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 10,
          child: DragTargetTile().dragTargetBigTile,
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 10,
          mainAxisCellCount: 10,
          child: DragTargetTile().dragTargetBigTile,
        ),
      ],
    ),
  ];


  List<Widget> getLayout(){
    return layoutTemplate;
  }

}