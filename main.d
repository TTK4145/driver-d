import std.concurrency;
import std.stdio;

import elevio;

void main(){

    initElevIO("localhost", 15657, 4);
    
    spawn(&pollCallButtons, thisTid);
    spawn(&pollFloorSensor, thisTid);
    spawn(&pollObstruction, thisTid);
    spawn(&pollStopButton,  thisTid);

    auto dirn = Dirn.up;

    while(true){
        receive(
            (CallButton a){
                a.writeln;
                callButtonLight(a.floor, a.call, true);
            },
            (FloorSensor a){
                a.writeln;
                floorIndicator(a);
                switch(a){
                case 0: 
                    dirn = Dirn.up;
                    motorDirection(dirn);
                    break;
                case 3: 
                    dirn = Dirn.down; 
                    motorDirection(dirn);
                    break;
                default: break;
                }
            },
            (Obstruction a){
                a.writeln;
                doorLight(a);
                motorDirection(a ? Dirn.stop : dirn);
            },
            (StopButton a){
                a.writeln;
                stopButtonLight(a);
                for(auto c = Call.min; c <= Call.max; c++){
                    foreach(f; 0..4){
                        callButtonLight(f, c, false);
                    }
                }
            },
        );
    }
}
