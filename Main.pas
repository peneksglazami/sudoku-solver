{
   Copyright 2006-2017 Andrey Grigorov
   Licensed under the Apache License, Version 2.0 (the "License"); you may not
   use this file except in compliance with the License. You may obtain a copy of
   the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
   License for the specific language governing permissions and limitations under
   the License.

                   Sudoku Solver 1.1
         программа для решения головоломки "Sudoku"
           (C) Andrey Grigorov, Cherepovets, 2006
}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, Menus;

type
  TSudokuSolverMainForm = class(TForm)
    StringGridTask: TStringGrid;
    BitBtnSolve: TBitBtn;
    StringGridAnswer: TStringGrid;
    LabelImpossible: TLabel;
    BitBtnClear: TBitBtn;
    Button1: TButton;
    procedure BitBtnSolveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnClearClick(Sender: TObject);
    procedure StringGridTaskGetEditMask(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure StringGridTaskKeyPress(Sender: TObject; var Key: Char);
    procedure StringGridTaskKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SudokuSolverMainForm: TSudokuSolverMainForm;
  row,col,square: array [1..9,1..9] of Boolean;
  mem: array [1..9,1..9] of Integer;

implementation

{$R *.dfm}

const
  sq: array [1..9,1..9] of Integer = ((1,1,1,2,2,2,3,3,3),
                                      (1,1,1,2,2,2,3,3,3),
                                      (1,1,1,2,2,2,3,3,3),
                                      (4,4,4,5,5,5,6,6,6),
                                      (4,4,4,5,5,5,6,6,6),
                                      (4,4,4,5,5,5,6,6,6),
                                      (7,7,7,8,8,8,9,9,9),
                                      (7,7,7,8,8,8,9,9,9),
                                      (7,7,7,8,8,8,9,9,9));

  INFINITY = 1000;

function SolveSudoku(Grid: TStringGrid; var ResultGrid: TStringGrid): Boolean;
//возвращает true, если головоломка разрешима
var
  res: array [1..9,1..9] of Integer; //массив для хранения результата
  row,col,square: array [1..9,1..9] of Boolean; //если True, то ход возможен
  st: array [1..81] of record r,c: Integer; end; // массив незаполненных клеток
  i,j,st_cnt: Integer; //количество незаполненных клеток
  Find: Boolean; //флаг "разрешимости" головоломки

procedure Init;
//считывание данных и инициализация переменных
var
  i,j,num: Integer;
begin
  Find:=False;
  FillChar(row,SizeOf(row),True);
  FillChar(col,SizeOf(col),True);
  FillChar(square,SizeOf(square),True);
  st_cnt:=0;
  for i:=1 to 9 do
    for j:=1 to 9 do
      if Trim(Grid.Cells[j-1,i-1]) = '' then
        begin
          Inc(st_cnt);
          st[st_cnt].r:=i;
          st[st_cnt].c:=j;
        end
      else
        begin
          num:=StrToInt(Grid.Cells[j-1,i-1]);
          res[i,j]:=num;
          row[i,num]:=False;
          col[j,num]:=False;
          square[sq[i,j],num]:=False;
        end;
end; //Init

procedure Solve(i: Integer);
var
  j: Integer;
begin
  if i = st_cnt+1 then //найдено решение
    Find:=True
  else
    for j:=1 to 9 do
      if row[st[i].r,j] and col[st[i].c,j] and square[sq[st[i].r,st[i].c],j] then
        begin
          //если число j можно поставить в клетку [st[i].r,st[i].c]
          row[st[i].r,j]:=False;
          col[st[i].c,j]:=False;
          square[sq[st[i].r,st[i].c],j]:=False;
          res[st[i].r,st[i].c]:=j;
          Solve(i+1);
          if Find then
            Exit;
          row[st[i].r,j]:=True;
          col[st[i].c,j]:=True;
          square[sq[st[i].r,st[i].c],j]:=True;
        end;
end; //Solve

begin
  Init;
  {R-}
  Solve(1);
  {R+}
  if Find then
    for i:=1 to 9 do
      for j:=1 to 9 do
        ResultGrid.Cells[j-1,i-1]:=IntToStr(res[i,j])
  else
    for i:=1 to 9 do
      for j:=1 to 9 do
        ResultGrid.Cells[j-1,i-1]:='';
  Result:=Find;
end; //SolveSudoku

function CountSolution(Grid: TStringGrid): Integer;
var
  res: array [1..9,1..9] of Integer; //массив для хранения результата
  row,col,square: array [1..9,1..9] of Boolean; //если True, то ход возможен
  st: array [1..81] of record r,c: Integer; end; // массив незаполненных клеток
  i,j: Integer;
  sol_cnt: Integer; //количество решений
  st_cnt: Integer; //количество незаполненных клеток

procedure Init;
//считывание данных и инициализация переменных
var
  i,j,num: Integer;
begin
  FillChar(row,SizeOf(row),True);
  FillChar(col,SizeOf(col),True);
  FillChar(square,SizeOf(square),True);
  st_cnt:=0;
  for i:=1 to 9 do
    for j:=1 to 9 do
      if Trim(Grid.Cells[j-1,i-1]) = '' then
        begin
          Inc(st_cnt);
          st[st_cnt].r:=i;
          st[st_cnt].c:=j;
        end
      else
        begin
          num:=StrToInt(Grid.Cells[j-1,i-1]);
          res[i,j]:=num;
          row[i,num]:=False;
          col[j,num]:=False;
          square[sq[i,j],num]:=False;
        end;
end; //Init

procedure Count(i: Integer);
var
  j: Integer;
begin
  if i = st_cnt+1 then //найдено решение
    Inc(sol_cnt)
  else
    for j:=1 to 9 do
      if row[st[i].r,j] and col[st[i].c,j] and square[sq[st[i].r,st[i].c],j] then
        begin
          //если число j можно поставить в клетку [st[i].r,st[i].c]
          row[st[i].r,j]:=False;
          col[st[i].c,j]:=False;
          square[sq[st[i].r,st[i].c],j]:=False;
          res[st[i].r,st[i].c]:=j;
          Count(i+1);
          if sol_cnt > INFINITY then
            Exit;
          row[st[i].r,j]:=True;
          col[st[i].c,j]:=True;
          square[sq[st[i].r,st[i].c],j]:=True;
        end;
end; //Count

begin
  Init;
  sol_cnt:=0;
  {$R-}
  Count(1);
  {$R+}
  Result:=sol_cnt;
end; //SolveSudoku


procedure TSudokuSolverMainForm.BitBtnSolveClick(Sender: TObject);
begin
  BitBtnSolve.Enabled:=False;
  LabelImpossible.Visible:=not SolveSudoku(StringGridTask,StringGridAnswer);
  BitBtnSolve.Enabled:=True;

end;

procedure TSudokuSolverMainForm.FormCreate(Sender: TObject);
begin
  FillChar(row,SizeOf(row),True);
  FillChar(col,SizeOf(col),True);
  FillChar(square,SizeOf(square),True);
  FillChar(mem,SizeOf(mem),0);
end;

procedure TSudokuSolverMainForm.BitBtnClearClick(Sender: TObject);
var
  i,j: Integer;
begin
  FillChar(row,SizeOf(row),True);
  FillChar(col,SizeOf(col),True);
  FillChar(square,SizeOf(square),True);
  FillChar(mem,SizeOf(mem),0);
  for i:=0 to 8 do
    for j:=0 to 8 do
      StringGridTask.Cells[i,j]:='';
  LabelImpossible.Visible:=False;    
end;

procedure TSudokuSolverMainForm.StringGridTaskGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  Value:='!9'; //устанавливаем маску
end;

procedure TSudokuSolverMainForm.StringGridTaskKeyPress(Sender: TObject; var Key: Char);
var
  n_row,n_col,num,num2,i,j: Integer;
begin
  if Key in ['1'..'9'] then
    begin
      n_row:=StringGridTask.Row+1;
      n_col:=StringGridTask.Col+1;
      num:=Ord(Key)-Ord('0');
      if row[n_row,num] and col[n_col,num] and square[sq[n_row,n_col],num] then
        begin
          if Length(Trim(StringGridTask.Cells[n_col-1,n_row-1])) = 1 then
            begin
              num2:=StrToInt(StringGridTask.Cells[n_col-1,n_row-1]);
              row[n_row,num2]:=True;
              col[n_col,num2]:=True;
              square[sq[n_row,n_col],num2]:=True;
              StringGridTask.Cells[n_col-1,n_row-1]:='';
            end;
          row[n_row,num]:=False;
          col[n_col,num]:=False;
          square[sq[n_row,n_col],num]:=False;
          mem[n_row,n_col]:=num;
        end
          else
            Key:=#0;
    end
  else
    Key:=#0;
end;

procedure TSudokuSolverMainForm.StringGridTaskKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  n_row,n_col,num: Integer;
begin
  if (Key = VK_DELETE) or (Key = VK_BACK) then
    if Trim(StringGridTask.Cells[StringGridTask.Col,StringGridTask.Row]) = '' then
      begin
        n_row:=StringGridTask.Row+1;
        n_col:=StringGridTask.Col+1;
        if mem[n_row,n_col] <> 0 then
          begin
            num:=mem[n_row,n_col];
            row[n_row,num]:=True;
            col[n_col,num]:=True;
            square[sq[n_row,n_col],num]:=True;
            mem[n_row,n_col]:=0;
          end;
      end;
end;

procedure TSudokuSolverMainForm.Button1Click(Sender: TObject);
var
  sol_cnt: Integer;
  mes: String;
begin
  sol_cnt:=CountSolution(StringGridTask);
  case sol_cnt of
    0: mes:='Судоку не имеет решения.';
    1: mes:='Судоку имеет единственное решение.';
    2..INFINITY: mes:='Количество различный решений: '+IntToStr(sol_cnt);
  else
    mes:='Судоку имеет более '+IntToStr(INFINITY)+' решений.';
  end;
  ShowMessage(mes);
end;

end.
