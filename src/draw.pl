% replace(+Index, +Element, +List, -Result)
% replaces the element at the given index with the given player piece
replace_piece_on_board(Index, Element, List, Result) :-
    (Element = 'X'; Element = 'O'),
    replace(Index, Element, List, Result)
    ;
    Result = List.

% make_board_by_layer_row(+Layer, +Board, -NewBoard)
% given an index, replaces the cell of the row with the given layer's cell
make_board_by_layer_row([],[],[]).
make_board_by_layer_row([L1,L2,L3,L4,L5,L6,L7,L8],B,R) :-
    replace_piece_on_board(0,L1,B,R1),
    replace_piece_on_board(1,L2,R1,R2),
    replace_piece_on_board(2,L3,R2,R3),
    replace_piece_on_board(3,L4,R3,R4),
    replace_piece_on_board(4,L5,R4,R5),
    replace_piece_on_board(5,L6,R5,R6),
    replace_piece_on_board(6,L7,R6,R7),
    replace_piece_on_board(7,L8,R7,R).

% make_board_by_layer_row(+Layer, +Board, -NewBoard)
% given an index, replaces the row of the board with the given layer's row
make_board_by_layer_col([],[],[]).
make_board_by_layer_col([HL|TL],[HB|TB],[HR|TR]) :-
    make_board_by_layer_row(HL,HB,HR),
    make_board_by_layer_col(TL,TB,TR).

% make_board_by_layer(+Layer, +Board, -NewBoard)
% start the loop that adds th layer to the board
make_board_by_layer(Layer, Board, NewBoard) :-
    make_board_by_layer_col(Layer, Board, NewBoard).

% make_board(+Layer0, +Layer1, +Layer2, +Layer3, -NewBoard)
% creates the board by stacking the layers
make_board(Layer0, Layer1, Layer2, Layer3, NewBoard) :-
    current_board(Board),
    make_board_by_layer(Layer0, Board, NewBoard1),
    make_board_by_layer(Layer1, NewBoard1, NewBoard2),
    make_board_by_layer(Layer2, NewBoard2, NewBoard3),
    make_board_by_layer(Layer3, NewBoard3, NewBoard).

% draw_Row(+Row)
% draws a row of the board
draw_Row([]).
draw_Row([H|T]) :-
   write(H),
   draw_Row(T).

% draw_Col(+Col)
% loops all the rows of the board and draws them
draw_Col([]).
draw_Col([H|T]) :-
    write(' X'),
    draw_Row(H),
    write('X'), nl,
    draw_Col(T).

% append_moves_to_board(+Board, +Moves, -NewBoard)
% called by display_game, appends the possible moves of each layer to the board
append_moves_to_board([],[],[]).
append_moves_to_board([H|T],[H1|T1],[H2|T2]) :-
    append(H,H1,H2),
    append_moves_to_board(T,T1,T2).

% draw_board(+Board)
% draws the board alone
draw_board(Board) :-
    write('  OOOOOOOO '), nl,
    draw_Col(Board),
    write('  OOOOOOOO '), nl.


% display_game(+GameState)
% draws the board and the possible moves
display_game([_, _, Board, Moves0, Moves1, Moves2, Moves3]) :-
    Separator = [['X'],['X'],['X'],['X'],['X'],['X'],['X'],['X']],
    SeparatorSpaces = [['X     X'],['X     X'],['X     X'],['X     X'],['X     X'],['X     X'],['X     X'],['X     X']],
    append_moves_to_board(Board, SeparatorSpaces, NewBoard0),
    append_moves_to_board(NewBoard0, Moves0, NewBoard1),
    append_moves_to_board(NewBoard1, Separator, NewBoard2),
    append_moves_to_board(NewBoard2, Moves1, NewBoard3),
    append_moves_to_board(NewBoard3, Separator, NewBoard4),
    append_moves_to_board(NewBoard4, Moves2, NewBoard5),
    append_moves_to_board(NewBoard5, Separator, NewBoard6),
    append_moves_to_board(NewBoard6, Moves3, NewBoard),
    write('-- Board ---    ---------- Possible Moves -----------'), nl,
    write('                  Layer0   Layer1   Layer2   Layer3  '), nl, nl,
    write('  OOOOOOOO       OOOOOOOO OOOOOOOO OOOOOOOO OOOOOOOO '), nl,
    draw_Col(NewBoard),
    write('  OOOOOOOO       OOOOOOOO OOOOOOOO OOOOOOOO OOOOOOOO '), nl.

% choose_piece_draw(+Pieces, +Index, +Offset)
% draws the piece selection menu
choose_piece_draw(Pieces, Index, Offset) :-
    nth0(Index, Pieces, Piece),
    Offset1 is Offset + 1,
    nth0(Offset, Piece, P1), nth0(Offset1, Piece, P2),
    write(P1), write(P2), write('  ').