% I wanted to clean up this code, but it seems the delivery limit was messed up and now I don not have time

% valid_moves_layer0_loop(+Row, +Index, -NewIndex, +MovesRow, -NewMovesRow)
% Checks where its possible to add a piece to the row
valid_moves_layer0_loop(C, Index, NewIndex, MovesRow, NewMovesRow) :-
    alphabet(Alphabet),
    nth0(0, C, C0), nth0(2, C, C2), nth0(4, C, C4), nth0(6, C, C6),
    nth0(Index, Alphabet, Alpha), NewIndex1 is Index + 1,
    (C0 = ' ' -> replace(0, Alpha, MovesRow, NewMoves11), replace(1, Alpha, NewMoves11, NewMoves1); NewMoves1 = MovesRow),
    nth0(NewIndex1, Alphabet, Alpha1), NewIndex2 is NewIndex1 + 1, 
    (C2 = ' ' -> replace(2, Alpha1, NewMoves1, NewMoves22), replace(3, Alpha1, NewMoves22, NewMoves2); NewMoves2 = NewMoves1),
    nth0(NewIndex2, Alphabet, Alpha2), NewIndex3 is NewIndex2 + 1, 
    (C4 = ' ' -> replace(4, Alpha2, NewMoves2, NewMoves33), replace(5, Alpha2, NewMoves33, NewMoves3); NewMoves3 = NewMoves2),
    nth0(NewIndex3, Alphabet, Alpha3), NewIndex is NewIndex3 + 1, 
    (C6 = ' ' -> replace(6, Alpha3, NewMoves3, NewMovesRoww), replace(7, Alpha3, NewMovesRoww, NewMovesRow); NewMovesRow = NewMoves3).

% valid_moves_layer0(+Layer0, +Index, -NewIndex, +Moves, -NewMoves)
% Checks where its possible to add a piece to the layer
valid_moves_layer0(Layer0, Index, NewIndex, Moves, NewMoves) :-
    nth0(0, Layer0, L00), nth0(2, Layer0, L02), nth0(4, Layer0, L04), nth0(6, Layer0, L06),
    MovesRow = [' ',' ',' ',' ',' ',' ',' ',' '],
    valid_moves_layer0_loop(L00, Index, NewIndex0, MovesRow, NewMovesRow0), replace(0, NewMovesRow0, Moves, NewMoves0), replace(1, NewMovesRow0, NewMoves0, NewMoves1),
    valid_moves_layer0_loop(L02, NewIndex0, NewIndex2, MovesRow, NewMovesRow2), replace(2, NewMovesRow2, NewMoves1, NewMoves2), replace(3, NewMovesRow2, NewMoves2, NewMoves3),
    valid_moves_layer0_loop(L04, NewIndex2, NewIndex4, MovesRow, NewMovesRow4), replace(4, NewMovesRow4, NewMoves3, NewMoves4), replace(5, NewMovesRow4, NewMoves4, NewMoves5),
    valid_moves_layer0_loop(L06, NewIndex4, NewIndex, MovesRow, NewMovesRow6), replace(6, NewMovesRow6, NewMoves5, NewMoves6), replace(7, NewMovesRow6, NewMoves6, NewMoves).

% valid_moves_layer1_loop(+Row1, +Row2, +Row1LayerBellow, +Row2LayerBellow, +Index, -NewIndex, +MovesRow1, +MovesRow2, -NewMovesRow1, -NewMovesRow2)
% Checks where its possible to add a piece to the row
valid_moves_layer1_loop(C, V, PC, PV, Index, NewIndex, MovesRow1, MovesRow2, NewMovesRow1, NewMovesRow2) :-
    alphabet(Alphabet),
    nth0(1, C, C1), nth0(2, C, C2), nth0(3, C, C3), nth0(4, C, C4), nth0(5, C, C5), nth0(6, C, C6),
    nth0(1, V, V1), nth0(2, V, V2), nth0(3, V, V3), nth0(4, V, V4), nth0(5, V, V5), nth0(6, V, V6),
    nth0(1, PC, PC1), nth0(2, PC, PC2), nth0(3, PC, PC3), nth0(4, PC, PC4), nth0(5, PC, PC5), nth0(6, PC, PC6),
    nth0(1, PV, PV1), nth0(2, PV, PV2), nth0(3, PV, PV3), nth0(4, PV, PV4), nth0(5, PV, PV5), nth0(6, PV, PV6),
    nth0(Index, Alphabet, Alpha), NewIndex1 is Index + 1,
    (C1 = ' ', C2 = ' ', V1 = ' ', V2 = ' ', PC1 \= ' ', PC2 \= ' ', PV1 \= ' ', PV2 \= ' ' -> replace(1, Alpha, MovesRow1, NewMoves11), replace(2, Alpha, NewMoves11, NewMoves12), replace(1, Alpha, MovesRow2, NewMoves21), replace(2, Alpha, NewMoves21, NewMoves22); NewMoves12 = MovesRow1, NewMoves22 = MovesRow2),
    nth0(NewIndex1, Alphabet, Alpha1), NewIndex2 is NewIndex1 + 1, 
    (C3 = ' ', C4 = ' ', V3 = ' ', V4 = ' ', PC3 \= ' ', PC4 \= ' ', PV3 \= ' ', PV4 \= ' ' -> replace(3, Alpha1, NewMoves12, NewMoves31), replace(4, Alpha1, NewMoves31, NewMoves32), replace(3, Alpha1, NewMoves22, NewMoves41), replace(4, Alpha1, NewMoves41, NewMoves42); NewMoves32 = NewMoves12, NewMoves42 = NewMoves22),
    nth0(NewIndex2, Alphabet, Alpha2), NewIndex is NewIndex2 + 1, 
    (C5 = ' ', C6 = ' ', V5 = ' ', V6 = ' ', PC5 \= ' ', PC6 \= ' ', PV5 \= ' ', PV6 \= ' ' -> replace(5, Alpha2, NewMoves32, NewMoves51), replace(6, Alpha2, NewMoves51, NewMovesRow1), replace(5, Alpha2, NewMoves42, NewMoves61), replace(6, Alpha2, NewMoves61, NewMovesRow2); NewMovesRow1 = NewMoves32, NewMovesRow2 = NewMoves42).

% valid_moves_layer1(+Layer0, +Layer1, +Index, -NewIndex, +Moves, -NewMoves)
% Checks where its possible to add a piece to the layer
valid_moves_layer1(Layer0, Layer1, Index, NewIndex, Moves, NewMoves) :-
    nth0(1, Layer1, L11), nth0(2, Layer1, L12), nth0(3, Layer1, L13), nth0(4, Layer1, L14), nth0(5, Layer1, L15), nth0(6, Layer1, L16),
    nth0(1, Layer0, PL01), nth0(2, Layer0, PL02), nth0(3, Layer0, PL03), nth0(4, Layer0, PL04), nth0(5, Layer0, PL05), nth0(6, Layer0, PL06),
    MovesRow1 = [' ',' ',' ',' ',' ',' ',' ',' '],
    MovesRow2 = [' ',' ',' ',' ',' ',' ',' ',' '],
    valid_moves_layer1_loop(L11, L12, PL01, PL02, Index, NewIndex0, MovesRow1, MovesRow2, NewMovesRow1, NewMovesRow2), replace(1, NewMovesRow1, Moves, NewMoves1), replace(2, NewMovesRow2, NewMoves1, NewMoves2),
    valid_moves_layer1_loop(L13, L14, PL03, PL04, NewIndex0, NewIndex1, MovesRow1, MovesRow2, NewMovesRow3, NewMovesRow4), replace(3, NewMovesRow3, NewMoves2, NewMoves3), replace(4, NewMovesRow4, NewMoves3, NewMoves4),
    valid_moves_layer1_loop(L15, L16, PL05, PL06, NewIndex1, NewIndex, MovesRow1, MovesRow2, NewMovesRow5, NewMovesRow6), replace(5, NewMovesRow5, NewMoves4, NewMoves5), replace(6, NewMovesRow6, NewMoves5, NewMoves).


% valid_moves_layer2_loop(+Row1, +Row2, +Row1LayerBellow, +Row2LayerBellow, +Index, -NewIndex, +MovesRow1, +MovesRow2, -NewMovesRow1, -NewMovesRow2)
% Checks where its possible to add a piece to the row
valid_moves_layer2_loop(C, V, PC, PV, Index, NewIndex, MovesRow1, MovesRow2, NewMovesRow1, NewMovesRow2) :-
    alphabet(Alphabet),
    nth0(2, C, C2), nth0(3, C, C3), nth0(4, C, C4), nth0(5, C, C5),
    nth0(2, V, V2), nth0(3, V, V3), nth0(4, V, V4), nth0(5, V, V5),
    nth0(2, PC, PC2), nth0(3, PC, PC3), nth0(4, PC, PC4), nth0(5, PC, PC5),
    nth0(2, PV, PV2), nth0(3, PV, PV3), nth0(4, PV, PV4), nth0(5, PV, PV5),
    nth0(Index, Alphabet, Alpha), NewIndex1 is Index + 1,
    (C2 = ' ', C3 = ' ', V2 = ' ', V3 = ' ', PC2 \= ' ', PC3 \= ' ', PV2 \= ' ', PV3 \= ' ' -> replace(2, Alpha, MovesRow1, NewMoves11), replace(3, Alpha, NewMoves11, NewMoves12), replace(2, Alpha, MovesRow2, NewMoves21), replace(3, Alpha, NewMoves21, NewMoves22); NewMoves12 = MovesRow1, NewMoves22 = MovesRow2),
    nth0(NewIndex1, Alphabet, Alpha1), NewIndex is NewIndex1 + 1, 
    (C4 = ' ', C5 = ' ', V4 = ' ', V5 = ' ', PC4 \= ' ', PC5 \= ' ', PV4 \= ' ', PV5 \= ' ' -> replace(4, Alpha1, NewMoves12, NewMoves31), replace(5, Alpha1, NewMoves31, NewMovesRow1), replace(4, Alpha1, NewMoves22, NewMoves41), replace(5, Alpha1, NewMoves41, NewMovesRow2); NewMovesRow1 = NewMoves12, NewMovesRow2 = NewMoves22).

% valid_moves_layer2(+Layer1, +Layer2, +Index, -NewIndex, +Moves, -NewMoves)
% Checks where its possible to add a piece to the layer
valid_moves_layer2(Layer1, Layer2, Index, NewIndex, Moves, NewMoves) :-
    nth0(2, Layer2, L22), nth0(3, Layer2, L23), nth0(4, Layer2, L24), nth0(5, Layer2, L25),
    nth0(2, Layer1, PL12), nth0(3, Layer1, PL13), nth0(4, Layer1, PL14), nth0(5, Layer1, PL15),
    MovesRow1 = [' ',' ',' ',' ',' ',' ',' ',' '],
    MovesRow2 = [' ',' ',' ',' ',' ',' ',' ',' '],
    valid_moves_layer2_loop(L22, L23, PL12, PL13, Index, NewIndex0, MovesRow1, MovesRow2, NewMovesRow2, NewMovesRow3), replace(2, NewMovesRow2, Moves, NewMoves2), replace(3, NewMovesRow3, NewMoves2, NewMoves3),
    valid_moves_layer2_loop(L24, L25, PL14, PL15, NewIndex0, NewIndex, MovesRow1, MovesRow2, NewMovesRow4, NewMovesRow5), replace(4, NewMovesRow4, NewMoves3, NewMoves4), replace(5, NewMovesRow5, NewMoves4, NewMoves).

% valid_moves_layer3_loop(+Row1, +Row2, +Row1LayerBellow, +Row2LayerBellow, +Index, -NewIndex, +MovesRow1, +MovesRow2, -NewMovesRow1, -NewMovesRow2)
% Checks where its possible to add a piece to the row
valid_moves_layer3_loop(C, V, PC, PV, Index, NewIndex, MovesRow1, MovesRow2, NewMovesRow1, NewMovesRow2) :-
    alphabet(Alphabet),
    nth0(3, C, C3), nth0(4, C, C4),
    nth0(3, V, V3), nth0(4, V, V4),
    nth0(3, PC, PC3), nth0(4, PC, PC4),
    nth0(3, PV, PV3), nth0(4, PV, PV4),
    nth0(Index, Alphabet, Alpha), NewIndex1 is Index + 1,
    (C3 = ' ', C4 = ' ', V3 = ' ', V4 = ' ', PC3 \= ' ', PC4 \= ' ', PV3 \= ' ', PV4 \= ' ' -> replace(3, Alpha, MovesRow1, NewMoves11), replace(4, Alpha, NewMoves11, NewMovesRow1), replace(3, Alpha, MovesRow2, NewMoves21), replace(4, Alpha, NewMoves21, NewMovesRow2); NewMovesRow1 = MovesRow1, NewMovesRow2 = MovesRow2).

% valid_moves_layer3(+Layer2, +Layer3, +Index, -NewIndex, +Moves, -NewMoves)
% Checks where its possible to add a piece to the layer
valid_moves_layer3(Layer2, Layer3, Index, NewIndex, Moves, NewMoves) :-
    nth0(3, Layer3, L33), nth0(4, Layer3, L34),
    nth0(3, Layer2, PL23), nth0(4, Layer2, PL24),
    MovesRow1 = [' ',' ',' ',' ',' ',' ',' ',' '],
    MovesRow2 = [' ',' ',' ',' ',' ',' ',' ',' '],
    valid_moves_layer3_loop(L33, L34, PL23, PL24, Index, NewIndex, MovesRow1, MovesRow2, NewMovesRow3, NewMovesRow4), replace(3, NewMovesRow3, Moves, NewMoves3), replace(4, NewMovesRow4, NewMoves3, NewMoves).

% valid_moves(+Board, -Moves)
% Checks where its possible to add a piece to each layer
valid_moves([_, _, _, Layer0, Layer1, Layer2, Layer3], [MovesLayer0, MovesLayer1, MovesLayer2, MovesLayer3]) :-
    current_board(Moves),
    Index = 0,
    valid_moves_layer0(Layer0, Index, NewIndex0, Moves, MovesLayer0),
    valid_moves_layer1(Layer0, Layer1, NewIndex0, NewIndex1, Moves, MovesLayer1),
    valid_moves_layer2(Layer1, Layer2, NewIndex1, NewIndex2, Moves, MovesLayer2),
    valid_moves_layer3(Layer2, Layer3, NewIndex2, NewIndex3, Moves, MovesLayer3).
