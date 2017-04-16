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

program SudokuSolver;

uses
  Forms,
  Main in 'Main.pas' {SudokuSolverMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Sudoku solver';
  Application.CreateForm(TSudokuSolverMainForm, SudokuSolverMainForm);
  Application.Run;
end.