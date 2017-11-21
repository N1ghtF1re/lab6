program lab6;

{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows;

const
  y=50;
  x=50;
  MaxY=50;
  MaxX=50;
  MaxRobots=3;
  MaxSpeed1 = 1;
  MaxSpeed2 = 2;
type
  TRobotsCoords = array[1..3, 1..MaxRobots] of integer;
  TPointMatrix = array [1..x, 1..(y*MaxRobots)] of string;
  TCityMatrix = array [1..x, 1..y] of byte;
  TError = string;
var ix,jy: byte;
  NRob: byte;
  RobotsInfo: TRobotsCoords;
  i,j,kn,b, finalTime:Byte;
  err:TError;
  PointMatrix: TPointMatrix;
  CityMatrix: TCityMatrix;
  cnt:Byte;
  starttime:byte;
  charfill: char;
  finalx, finaly: Byte;

Function IntToStr(I : Longint) : String;
Var S : String;
Begin
 Str(I, S);
 IntToStr:=S;
End;

procedure push(var arr:TPointMatrix; beginel: Integer; elem: string; line: integer);
var i:integer;
var isEnd: Boolean;
begin
  i:=beginel;
  isEnd:=false;
  while ( (i < beginel+MaxX) and (not isEnd) ) do
  begin
    if (arr[line, i] = '') then
    begin
      arr[line, i] := elem;
      isEnd := true;
    end;
    Inc(i);
  end;
end;

function isElementRepeated(arr:TPointMatrix; el: string; line: Integer):boolean;
var i:Integer;
brk:Boolean;
Repeated:Boolean;
tmp:string;
begin
  i:=1;
  brk:=false;
  Repeated:=false;
  while ((i <MaxX*MaxRobots) and (not brk)) do
  begin
    if (arr[line,i] = el) then
    begin
      brk:=True;
      Repeated:=True;
    end;
    tmp:=el[4]+el[5]+el[3]+el[1]+el[2];
    if (arr[line,i] = tmp) then
    begin
      brk:=True;
      Repeated:=True;
    end;
    inc(i);
  end;
  isElementRepeated:=Repeated;
end;

procedure searchRelatedPoint(robot,speed, x, y, step: integer);
var rob, time,cf: integer;
currel: string;
begin
  cf:= 1 + (robot-1)*MaxX;
  rob:=robot;
  Case speed of
    1 : time:=2;
    2 : time:=1;
  end;
  if (step < 12) then
  begin
    if ( ((x-2) > 0) and (CityMatrix[y,x-2] <> 0) and (CityMatrix[y,x-1] = 2)) then
    begin
      currel := IntToStr(x) + IntToStr(y) + '>' + IntToStr(x-2) + IntToStr(y);
      if(not isElementRepeated(PointMatrix, currel, step)) then
        push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x-2,y, step+time);
    end;
    if ( ((x+2) <= ix) and (CityMatrix[y,x+2] <> 0) and (CityMatrix[y,x+1] = 2)) then
    begin
      currel := IntToStr(x) + IntToStr(y) + '>' + IntToStr(x+2) + IntToStr(y);
      if(not isElementRepeated(PointMatrix, currel, step)) then
        push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x+2,y, step+time);
    end;
    if ( ((y-2) > 0) and (CityMatrix[y-2,x] <> 0) and (CityMatrix[y-1,x] = 2)) then
    begin
      currel := IntToStr(x) + IntToStr(y) + '>' + IntToStr(x) + IntToStr(y-2);
      if(not isElementRepeated(PointMatrix, currel, step)) then
        push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x,y-2, step+time);
    end;
    if (((y+2) <= jy) and (CityMatrix[y+2,x] <> 0) and (CityMatrix[y+1,x] = 2)) then
    begin
      currel := IntToStr(x) + IntToStr(y) + '>' + IntToStr(x) + IntToStr(y+2);
      if(not isElementRepeated(PointMatrix, currel, step)) then
        push(PointMatrix,cf,currel,step);
      searchRelatedPoint(rob,speed, x,y+2, step+time);
    end;
  end;
end;

function searchSameElements(var arr:TPointMatrix; el: string; line:Integer):integer;
var j,time, count: Integer;
prevs, currs, els,elneed,currneed:string;
brk:boolean;
begin
  brk:=false;
  count:=1;
  if (el <> '') then
  begin
    j:=MaxY+1;
    prevs:=el[1] + el[2];
    while((j<MaxY*MaxRobots) and (not brk)) do
    begin
      if (arr[line, j] <> '') then
      begin
        currs :=  arr[line,j][1] + arr[line,j][2];
        els := el[1] + el[2];
        currneed:= arr[line,j][4] + arr[line,j][5];
        elneed:= el[4] + el[5];
        //write(' - ', count:4);
        {Writeln(currs);
        writeln;
        Writeln(currs);
        Writeln(Prevs);   }
        if ((currneed = elneed)
            and (currs <> prevs)
            and (currs <> els))
        then
        begin
          //Writeln('curr', currs);
          //Writeln('prev', prevs);
          //Writeln('els', els);
          //writeln(currneed);
          //writeln(elneed);
          //writeln(line);
          //writeln(count);
          Inc(count);
          prevs:=currs;
          j:= count*MaxY{(j mod MaxY) + MaxY};
        end;
      end;
      inc(j);
    end;
  end;

  searchSameElements := count;
end;

function getTime(var arr: TPointMatrix; robots: integer): Integer;
var i,j,rep,time: Integer;
brk:boolean;
begin
  brk:=false;
  i:=1;
  while((i<=MaxX) and (not brk)) do
  //for i :=1 to MaxX do
  begin
    j:=1;
    while((j<MaxY{*MaxRobots}) and (not brk)) do
    begin
      //for j :=1 to MaxY*MaxRobots do
      if(arr[i,j] <> '') then
      begin
        rep:=searchSameElements(PointMatrix, arr[i,j],i);
        if (rep = robots) then
        begin
          brk:=true;
          time:=i;
          finalx:=StrToInt(PointMatrix[i,j][5]);
          finaly:=StrToInt(PointMatrix[i,j][4]);
          {Writeln(j,' ',i);
          Writeln(arr[i,j]);}
        end;
      end;
      inc(j);
    end;
    inc(i);
  end;
  if (rep <> robots) then
    time:= 0;
  getTime:= time;
end;

procedure createCityVisualisation(var arr:TCityMatrix; finalmod:boolean=false);
var i,j:Byte;
begin
  Writeln;
  write('+');
  for i:=1 to (ix*3+2) do
    write('-');
  Writeln('+');
  for i:= 1 to ix do
  begin
    write('|');
    for j:=1 to jy do
    begin
      cnt:=0;
      if (finalmod) then
      begin
        if ((i = finalx) and (j = finaly)) then
        begin
          inc(cnt);
          write(' ', NRob,'R');
        end;
      end
      else
      begin
        for b:=1 to NRob do
        begin
          if (RobotsInfo[1,b] = j) and (RobotsInfo[2,b] = i) then
          begin
            write('R':3);
            inc(cnt);
          end;
        end;
      end;
      if ((arr[i,j] = 1) and (cnt = 0)) then
      begin
        inc(cnt);
        write('D':3);
      end;
      if ((arr[i,j] = 2) and (cnt = 0)) then
      begin
        inc(cnt);
        write('=':3);
      end;
      if (cnt = 0) then
        write(' ':3);
    end;
    writeln('  |');
  end;
  write('+');
  for i:=1 to (ix*3+2) do
    write('-');
  Writeln('+');
  Writeln;
end;

procedure writeVisitedPointsMatrix(arr:TPointMatrix);
begin
  for i :=1 to 12 do
  begin
    for j :=1 to 50 do
        write (arr[i,j], ' ');
   writeln ;
  end;
  Writeln;
  for i :=1 to 12 do
  begin
    for j :=51 to 100 do
        write ( arr[i,j], ' ');
   writeln ;
  end;
  for i :=1 to 12 do
  begin
    for j :=101 to 150 do
        write ( arr[i,j], ' ');
   writeln ;
  end;
end;

begin
  // CITY AND ROBOTS INFORMATION BEGIN
  ix:=3*2-1; //  Width and length
  jy:=3*2-1; //  of the city

  CityMatrix[1,1]:=1;  // 1 - Point
  CityMatrix[2,1]:=2;  // 2 - Road
  CityMatrix[3,1]:=1;
  CityMatrix[3,2]:=2;
  CityMatrix[3,3]:=1;
  CityMatrix[3,4]:=2;
  CityMatrix[3,5]:=1;
  CityMatrix[2,5]:=2;
  CityMatrix[1,5]:=1;
  CityMatrix[4,3]:=2;
  CityMatrix[5,1]:=1;
  CityMatrix[5,2]:=2;
  CityMatrix[5,3]:=1;
  CityMatrix[5,4]:=2;
  CityMatrix[5,5]:=1;

  NRob:= 3; // Number of robots, max - 3;
  RobotsInfo[1,1] := 1; // Robot's coord X
  RobotsInfo[2,1] := 1; // Robot's coord Y
  RobotsInfo[3,1] := 1; // Robot's speed (1/2)
  RobotsInfo[1,2] := 5;
  RobotsInfo[2,2] := 5;
  RobotsInfo[3,2] := 1;
  RobotsInfo[1,3] := 1;
  RobotsInfo[2,3] := 5;
  RobotsInfo[3,3] := 2;
  // CITY AND ROBOTS INFORMATION END

  createCityVisualisation(CityMatrix);

  Writeln('The city contains points [',(ix div 2)+1,',',jy div 2+1,']');
  Writeln(NRob, ' robots drive around the city');
  Writeln('+-------+---------+---------+---------+');
  Writeln('| Robot | Initial | Initial |  Robot  |');
  Writeln('| Num.  | coord X | coord Y |  speed  |');
  Writeln('+-------+---------+---------+---------+');
  for i:=1 to NRob do
  begin
    writeln('|', i:7, '|', RobotsInfo[1,i]:9, '|', RobotsInfo[2,i]:9, '|', RobotsInfo[3,i]:9, '|');
    Writeln('+-------+---------+---------+---------+');
  end;

  for kn:=1 to NRob do
  begin
    Case RobotsInfo[3,kn] of
      1 : starttime:=2;
      2 : starttime:=1;
    end;
    searchRelatedPoint(kn,RobotsInfo[3,kn],RobotsInfo[1,kn],RobotsInfo[2,kn],starttime);
  end;

  // writeVisitedPointsMatrix(PointMatrix);

  Writeln;
  finalTime := getTime(PointMatrix,NRob)*5;
  if  (finalTime = 0) then
    Writeln('Robots will never meet :c')
  else
    Writeln('Hooray! Robots met later ',(finalTime/10):0:1, 'T');

  createCityVisualisation(CityMatrix, true);

  Writeln(#10, 'Press any key to exit');
  Readln;

end.
