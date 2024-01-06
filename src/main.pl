:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(random)).

:- consult(draw).
:- consult(data).
:- consult(valid_moves).

% index_of_element(+Element, +List, -Index)
% returns the index of the element in the list
index_of_element(E,[E|_],0).
index_of_element(E,[_|T],Res) :-
    index_of_element(E,T,Cur_rest),
    Res is Cur_rest + 1.

% replace(+Index, +Element, +List, -Result)
% replaces the element in the index of the list with the given element
replace(Index, Element, List, Result) :-
  nth0(Index, List, _, R),
  nth0(Index, Result, Element, R).

% move_aux(+Piece, +Index, +LayerIndex, +Layer, -NewLayer)
% moves the piece to the given index in the layer
move_aux(Piece, Index, LayerIndex, Layer, NewLayer) :-
    LayerIndexAux is 4 - LayerIndex,
    (LayerIndex = 3, Row is 3; Row is LayerIndex + div(Index, LayerIndexAux) * 2),
    (LayerIndex = 3, Col is 3; Col is LayerIndex + mod(Index, LayerIndexAux) * 2),
    Row1 is Row + 1,
    Col1 is Col + 1,
    nth0(Row, Layer, R1), nth0(Row1, Layer, R2),
    nth0(Col, R1, C1), nth0(Col1, R1, C2), nth0(Col, R2, C3), nth0(Col1, R2, C4),
    nth0(0, Piece, P1), nth0(1, Piece, P2), nth0(2, Piece, P3), nth0(3, Piece, P4),
    replace(Col, P1, R1, NewR1), replace(Col1, P2, NewR1, NewR11), replace(Col, P3, R2, NewR2), replace(Col1, P4, NewR2, NewR22),
    replace(Row, NewR11, Layer, NewLayer1), replace(Row1, NewR22, NewLayer1, NewLayer).

% move(+GameState, +Move, -NewGameState)
% selects the  correct layer and calls move_aux to move the piece
move([CurrentPlayer, GameMode, _, Layer0, Layer1, Layer2, Layer3], [Piece, Index], [NewCurrentPlayer, GameMode, _, NewLayer0, NewLayer1, NewLayer2, NewLayer3]) :-
    dif(CurrentPlayer, NewCurrentPlayer),
    (
    Index < 16, move_aux(Piece, Index, 0, Layer0, NewLayer0), NewLayer1 = Layer1, NewLayer2 = Layer2, NewLayer3 = Layer3;
    Index < 25, NewIndex1 is Index - 16, move_aux(Piece, NewIndex1, 1, Layer1, NewLayer1), NewLayer0 = Layer0, NewLayer2 = Layer2, NewLayer3 = Layer3;
    Index < 29, NewIndex2 is Index - 25, move_aux(Piece, NewIndex2, 2, Layer2, NewLayer2), NewLayer0 = Layer0, NewLayer1 = Layer1, NewLayer3 = Layer3;
    NewIndex3 is Index - 29, move_aux(Piece, NewIndex3, 3, Layer3, NewLayer3), NewLayer0 = Layer0, NewLayer1 = Layer1, NewLayer2 = Layer2).

% choose_piece(+Pieces)
% displays the pieces and asks the user to choose one
choose_piece(Piece) :-
    Pieces = [['X','X','O','O'], ['O','O','X','X'], ['X','O','X','O'], ['O','X','O','X'], ['X','O','O','X'], ['O','X','X','O']],
    write('0   1   2   3   4   5'), nl,
    choose_piece_draw(Pieces, 0, 0), choose_piece_draw(Pieces, 1, 0), choose_piece_draw(Pieces, 2, 0), choose_piece_draw(Pieces, 3, 0), choose_piece_draw(Pieces, 4, 0), choose_piece_draw(Pieces, 5, 0), nl,
    choose_piece_draw(Pieces, 0, 2), choose_piece_draw(Pieces, 1, 2), choose_piece_draw(Pieces, 2, 2), choose_piece_draw(Pieces, 3, 2), choose_piece_draw(Pieces, 4, 2), choose_piece_draw(Pieces, 5, 2), nl,
    nl, write('Choose a piece: '),
    get_code(A),
    get_char(B),
    between(48, 57, A), !,
    C is A - 48,
    nth0(C, Pieces, Piece).

% choose_move(+GameState, +Level, -Piece)
% called for computer moves, chooses a move depending on the bot level
choose_move([_, _, _, _, _, _, _], Level, Piece) :-
    (Level = 1 ->
        Pieces = [['X','X','O','O'], ['O','O','X','X'], ['X','O','X','O'], ['O','X','O','X'], ['X','O','O','X'], ['O','X','X','O']],
        random_member(Piece, Pieces)
        ;
        Pieces = [['X','X','O','O'], ['O','O','X','X'], ['X','O','X','O'], ['O','X','O','X'], ['X','O','O','X'], ['O','X','X','O']],
        random_member(Piece, Pieces)
    ).

% combine_lists_of_lists(+List, +List, -Result)
% combines two lists of lists into one
combine_lists_of_lists([], J, J).
combine_lists_of_lists([H|T], J, R) :-
    append(J, H, R1),
    combine_lists_of_lists(T, R1, R).

% game_loop(+GameState)
% main game loop
% displays the board, asks for input and calls move
game_loop([CurrentPlayer, GameMode, Board, Layer0, Layer1, Layer2, Layer3]) :-
    nl, write('------------------------'), nl,
    write('-------  Blinq  -------'), nl, nl,
    make_board(Layer0, Layer1, Layer2, Layer3, NewBoard),
    valid_moves([CurrentPlayer, GameMode, NewBoard, Layer0, Layer1, Layer2, Layer3], [MovesLayer0, MovesLayer1, MovesLayer2, MovesLayer3]),
    display_game([CurrentPlayer, GameMode, NewBoard, MovesLayer0, MovesLayer1, MovesLayer2, MovesLayer3]),
    nl,
    (CurrentPlayer = false -> write('Player O turn: '); write('Player X turn: ')),
    alphabet(Alphabet),
    ((GameMode = 1; GameMode = 2, CurrentPlayer = false) -> 
        get_char(A),
        get_char(B), nl
        ;
        random_member(A, Alphabet),
        write(A), nl
    ),
    AvailableMoves = [],
    combine_lists_of_lists(MovesLayer0, AvailableMoves, AvailableMoves0), combine_lists_of_lists(MovesLayer1, AvailableMoves0, AvailableMoves1), combine_lists_of_lists(MovesLayer2, AvailableMoves1, AvailableMoves2), combine_lists_of_lists(MovesLayer3, AvailableMoves2, AvailableMoves3),
    (index_of_element(A, AvailableMoves3, Check), index_of_element(A, Alphabet, C) ->
        ((GameMode = 1; GameMode = 2, CurrentPlayer = false) -> 
            choose_piece(Piece)
            ;
            choose_move([CurrentPlayer, GameMode, NewBoard, Layer0, Layer1, Layer2, Layer3], 1, Piece)
        ),
        move([CurrentPlayer, GameMode, Board, Layer0, Layer1, Layer2, Layer3], [Piece, C], [NewCurrentPlayer, GameMode, Board, NewLayer0, NewLayer1, NewLayer2, NewLayer3]),
        game_loop([NewCurrentPlayer, GameMode, NewBoard, NewLayer0, NewLayer1, NewLayer2, NewLayer3])
        ;
        nl, write('Invalid input. Try again'),
        game_loop([CurrentPlayer, GameMode, NewBoard, Layer0, Layer1, Layer2, Layer3])
    ).

% play
% starts the game
play :-
    layer_0(Layer0),
    layer_1(Layer1),
    layer_2(Layer2),
    layer_3(Layer3),
    nl,
    write('------------------------'), nl,
    write('-------  Blinq  -------'), nl,
    nl,
    write('1 - Player vs Player'), nl,
    write('2 - Player vs Computer'), nl,
    write('3 - Computer vs Computer'), nl,
    write('Select a game mode: '),
    get_code(A),
    get_char(B),
    between(49, 51, A), !,
    C is A - 48,
    CurrentPlayer = false, % false - O, true - X
    game_loop([CurrentPlayer, C, Board, Layer0, Layer1, Layer2, Layer3]).