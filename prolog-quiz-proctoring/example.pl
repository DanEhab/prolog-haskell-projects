% Example run for the quiz proctoring system.
% Usage:  swipl -q -g run -t halt example.pl

:- consult('proctoring.pl').

tas([ta(hassan, sat), ta(slim, thu), ta(nourhan, mon), ta(ahmed, sun)]).

% Six days, five slots each; every slot lists the TAs who teach in it.
teaching_schedule([
    day(sat, [[slim], [], [nourhan], [], []]),
    day(sun, [[hassan], [slim], [], [], []]),
    day(mon, [[], [], [], [hassan], [slim]]),
    day(tue, [[hassan, slim], [nourhan], [], [], []]),
    day(wed, [[], [], [ahmed], [], []]),
    day(thu, [[], [], [], [], []])
]).

quizzes([
    quiz(csen403, sat, 2, 2),   % two proctors needed
    quiz(csen401, sat, 2, 1),   % same slot as csen403
    quiz(math401, tue, 1, 2)
]).

run :-
    tas(TAs), teaching_schedule(Schedule), quizzes(Quizzes),
    assign_proctors(TAs, Quizzes, Schedule, Proctoring), !,
    forall(member(proctors(quiz(Course, Day, Slot, _), Names), Proctoring),
           format("~w on ~w, slot ~w  ->  ~w~n", [Course, Day, Slot, Names])).
