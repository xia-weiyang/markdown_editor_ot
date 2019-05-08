import 'package:flutter/material.dart';

class CustomizePhysics extends ScrollPhysics {

  const CustomizePhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  CustomizePhysics applyTo(ScrollPhysics ancestor) {
    return CustomizePhysics(parent: buildParent(ancestor));
  }


  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => false;

  @override
  bool get allowImplicitScrolling => false;


  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    return 0;
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return null;
  }
}
