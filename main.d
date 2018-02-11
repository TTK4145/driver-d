import std.concurrency;
import std.stdio;

import elevio;

void main(){

    initElevIO("localhost", 15657, 4);
    
    spawn(&pollCallButtons, thisTid);
    spawn(&pollFloorSensor, thisTid);
    spawn(&pollObstruction, thisTid);
    spawn(&pollStopButton,  thisTid);

    while(true){
        receive(
            (CallButton a){
                a.writeln;
            },
            (FloorSensor a){
                a.writeln;
            },
            (Obstruction a){
                a.writeln;
            },
            (StopButton a){
                a.writeln;
            },
        );
    }
}