:- ['fulldisplay.pl'].
:- ['entailment.pl']. 
:- ['properties.pl'].

/** lexicon **/

/** ichidan - ru verbs **/
japanese([[t,a,b,e],[r,u]], [verb, ru, dictionary]).

/** godan - u verbs **/
japanese([[k,a],[u]],[verb, u, dictionary]).
japanese([[m,a,t],[u]], [verb, u, dictionary]).
japanese([[t,o,r],[u]], [verb, u, dictionary]).
japanese([[y,o,m],[u]], [verb, u, dictionary]).
japanese([[a,s,o,b],[u]], [verb, u, dictionary]).
japanese([[s,i,n],[u]], [verb, u, dictionary]).
japanese([[k,a,k],[u]], [verb, u, dictionary]).
japanese([[i,s,o,g],[u]], [verb, u, dictionary]).
japanese([[h,a,n,a,s],[u]], [verb, u, dictionary]).

/** verb stems **/
japanese([[i],[m,a,s,u]], [stem, long]).
japanese([[r,a,r],[e,r,u]], [stem, potential]).

/** there are multiple different forms for te form so i seperated the ones that proved to be difficult to distinguish with properties **/
japanese([i,Y,e], [stem, u, teform]):- 
   phone(Y), cns(Y), alv(Y), cor(Y), not(nas(Y)), not(cnt(Y)). 
japanese([n,d,e], [stem, u, teform]).
japanese([t,t,e], [stem, u, teform]).
japanese([t,e], [stem, ru, teform]).
    
/** this is for ru verb conjugationing to long form they simply drop the ru and add on masu **/
japanese(X, [verb, ru, long]) :-
    japanese([A,_], [verb, ru, dictionary]),
    japanese([_,D], [stem, long]),
    append(A,D,X).
 
 /** this is for u verb conjugatiing to long form they simply drop the ru and add on imasu **/
japanese(X, [verb, u, long]) :-
    japanese([A,_], [verb, u, dictionary]),
    japanese(B, [stem, long]),
    append(A,B,X).

/** this is ru verbs conjugating to poteinal this one has the special case of ra **/
japanese(X, [verb, ru, potential]) :-
    japanese([A,_], [verb, ru, dictionary]),
    japanese(B, [stem, potential]),
    append(A,B,X).

/** u verbs conjugating to poteinal simply remove u and add eru **/
japanese(X, [verb, u, potential]) :-
    japanese([A,_], [verb, u, dictionary]),
    japanese([_,D], [stem, potential]),
    append(A,D,X).

/** Below are te-form cases **/

/** case 1: it is a ru verb **/
japanese(X, [verb, ru, teform]) :-
    japanese([A,_],[verb, ru, dictionary]),
    japanese(B,[stem, ru, teform]),
    append(A,B,X).
    
/** case 2: u verb but it is su **/
japanese(X, [verb, u, teform]) :-
    japanese([A,_],[verb, u, dictionary]),
    japanese(B, [stem, u, teform]),
    append(A,B,X),
    B =[H|_],
    B = [_|[M|_]],
    last(A,C),
    sib(C),
    alv(M),
    not(cns(H)),
    not(voi(M)).

/**case 3: u verb but it is gu or ku, they use the i,Y,t stem which the Y assimilates in vocalization**/
japanese(X, [verb, u, teform]) :-
    japanese([A,_],[verb, u, dictionary]),
    japanese(B, [stem, u, teform]),
    B =[H|_],
    not(cns(H)),
    B = [_|[M|_]],
    last(A,C),
    vel(C),
    voi(M) <=> voi(C),
    remove_last(A,D),
    append(D,B,X).

/**case 4: u verb but it is u **/
japanese(X, [verb, u, teform]) :-
    japanese([A,_],[verb, u, dictionary]),
    japanese(B, [stem, u, teform]),
    append(A,B,X),
    last(A,C),
    not(cns(C)),
    B =[H|_],
    alv(H),
    not(nas(H)).

/**case 5: u verb but it is tu or ru **/
japanese(X, [verb, u, teform]) :-
    japanese([A,_],[verb, u, dictionary]),
    japanese(B, [stem, u, teform]),
    last(A,C),
    B = [H|_],
    cns(C),
    not(nas(H)),
    alv(C),
    not(nas(C)),
    not(sib(C)),
    alv(C) <=> alv(H),
    remove_last(A,M),
    append(M,B,X).

/**case 6: u verb but it is mu or nu **/
japanese(X, [verb, u, teform]) :-
    japanese([A,_],[verb, u, dictionary]),
    japanese(B, [stem, u, teform]),
    last(A,C),
    B = [H|_],
    nas(C),
    nas(C)<=> nas(H),
    remove_last(A,M),
    append(M,B,X).

/**case 7: u verb but it is bu **/
japanese(X, [verb, u, teform]) :-
    japanese([A,_],[verb, u, dictionary]),
    japanese(B, [stem, u, teform]),
    last(A,C),
    lab(C),
    not(nas(C)),
    B = [H|_],
    nas(H),
    remove_last(A,M),
    append(M,B,X).
    
/** a recursive function to remove the last letter of the list **/
remove_last([X|Y], [X|RemoveLast]) :- 
    remove_last(Y, RemoveLast).
remove_last([_], []).