  // auto door
new bool:Salon3Door, bool:Salon2Door, bool:PoliceGate, bool:PoliceGate2;
new drugisalon1,
    drugisalon2,
    trecisalon1,
    trecisalon2,
    policegate,
    policegate2;


// sa mga stock or sa forward
DefineGatesAndDoors( ) {

    drugisalon1 = CreateDynamicObject(1569, 2055.68701, -1922.37341, 12.72000,   0.00000, 0.00000, 0.00000 );
    drugisalon2 = CreateDynamicObject(1569, 2058.67578, -1922.35339, 12.72000,   0.00000, 0.00000, -179.7000 );
    Salon2Door = false;

    policegate = CreateDynamicObject(980, 1266.8954, -1601.7847, 9.8481,   0.00000, 0.00000, -30.8400);
    PoliceGate = false;

    policegate2 = CreateDynamicObject(980, 1210.2916, -1642.6067, 7.6481,   0.00000, 0.00000, 180.0000);
    PoliceGate2 = false;

    trecisalon1 = CreateDynamicObject(1569, 617.02716, -1510.78259, 14.35711,   0.00000, 0.00000, 90.41999 );
    trecisalon2 = CreateDynamicObject(1569, 616.99652, -1507.77271, 14.35711,   0.00000, 0.00000, 270.77997 );
    Salon3Door = false;

}


//------------------------------------------------------------------------------
forward TreciSalonDoorClose( );
public TreciSalonDoorClose( ) {
    MoveDynamicObject( trecisalon1, 617.02716, -1510.78259, 14.35711, 2.00 );
    MoveDynamicObject( trecisalon2, 616.99652, -1507.77271, 14.35711, 2.00 );
    Salon3Door = false;
}

forward PoliceClose( );
public PoliceClose( ) {
    MoveDynamicObject( policegate, 1266.8954, -1601.7847, 9.6398, 2.00 );
    PoliceGate = false;
}
forward PoliceClose2( );
public PoliceClose2( ) {
    MoveDynamicObject( policegate2, 1210.2916, -1642.6067, 7.6481, 2.00 );
    PoliceGate2 = false;
}

forward DrugiSalonDoorClose( );
public DrugiSalonDoorClose( ) {
    MoveDynamicObject( drugisalon1, 2055.68701, -1922.37341, 12.72000, 2.00 );
    MoveDynamicObject( drugisalon2, 2058.67578, -1922.35339, 12.72000, 2.00 );
    Salon2Door = false;
}


stock ccrpmappings() {

    return 1;
}