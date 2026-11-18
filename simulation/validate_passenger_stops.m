function validate_passenger_stops()
clear passenger_stop_controller
p=[2.19;-.26;0]; d=[.92;-1.1;0];
[v,s]=passenger_stop_controller(.25,d,0,0,0);
assert(v==.25 && s==0,'Drop-off must not occur before pickup.');
[v,s]=passenger_stop_controller(.25,p,.2,1,0);
assert(v==0 && s==1);
passenger_stop_controller(.25,p,.04,3,0);
[v,s]=passenger_stop_controller(.25,p,.03,5.99,0);
assert(v==0 && s==1,'Pickup must hold for five seconds.');
[v,s]=passenger_stop_controller(.25,p,.03,6,0);
assert(v==.25 && s==2);
[v,s]=passenger_stop_controller(.25,p,0,6.1,0);
assert(v==.25 && s==2,'Pickup must not retrigger.');
passenger_stop_controller(.25,d,0,9,0);
passenger_stop_controller(.25,d,.1,11,0);
[v,s]=passenger_stop_controller(.25,d,.03,13.99,0);
assert(v==0 && s==3,'Drop-off must hold for five seconds.');
[v,s]=passenger_stop_controller(.25,d,.03,14,0);
assert(v==.25 && s==4);
[v,s]=passenger_stop_controller(.25,p,0,20,0);
assert(v==.25 && s==4,'Completed mission must not repeat.');
clear passenger_stop_controller
[v,s]=passenger_stop_controller(.25,p,0,0,7);
assert(v==.25 && s==0,'Startup localization must not trigger a stop.');
[v,s]=passenger_stop_controller(.25,p+[1.01;0;0],0,8,7);
assert(v==.25 && s==0,'Outside radius must not trigger.');
[v,s]=passenger_stop_controller(.25,p,0,9,7);
assert(v==0 && s==1);
fprintf('PASSENGER_SEQUENCE_TESTS_PASSED\n');
end
