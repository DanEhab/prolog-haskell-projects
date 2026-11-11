
assign_proctors(AllTAs,Quizzes,TeachingSchedule,ProctoringSchedule):-
check_Len(AllTAs,Quizzes),
free_schedule(AllTAs,TeachingSchedule,FreeSchedule),
assign_quizzes(Quizzes,FreeSchedule,ProctoringSchedule).

check_Len(_,[]).
check_Len(AllTAs,[quiz(_,_,_,N)|T]):-
length(AllTAs,L),L>=N,check_Len(AllTAs,T).

free_schedule([ta(Name,Day_Off)|T],[day(DayName,DaySchedule)|T1],[day(sat, D1),
						day(sun, D2),
						day(mon, D3),
						day(tue, D4),
						day(wed, D5),
						day(thu, D6)]):-
		week_schedule([ta(Name,Day_Off)|T],[day(DayName,DaySchedule)|T1],[D1,D2,D3,D4,D5,D6]).
		
		
			
	

			
week_schedule(_,[],[]).			
week_schedule([ta(Name,Day_Off)|T],[day(DayName,DaySchedule)|T1],[D|Y]):-
			day_Schedule([ta(Name,Day_Off)|T],day(DayName,DaySchedule),D),
			week_schedule([ta(Name,Day_Off)|T],T1,Y).
				 
				
				
day_Schedule([ta(Name,Day_Off)|T],day(DayName,[X1,X2,X3,X4,X5]),[S1,S2,S3,S4,S5]):-
				
				
				slot_Schedule([ta(Name,Day_Off)|T],DayName,X1,Y1),
				slot_Schedule([ta(Name,Day_Off)|T],DayName,X2,Y2),
				slot_Schedule([ta(Name,Day_Off)|T],DayName,X3,Y3),
				slot_Schedule([ta(Name,Day_Off)|T],DayName,X4,Y4),
				slot_Schedule([ta(Name,Day_Off)|T],DayName,X5,Y5),
				permutation(Y1,S1),
				permutation(Y2,S2),
				permutation(Y3,S3),
				permutation(Y4,S4),
				permutation(Y5,S5).
slot_Schedule([],_,_,[]).				

slot_Schedule([ta(Name,Day_Off)|T],Day,SlotSchedule,[Name|Y]):-
				
				\+member(Name,SlotSchedule),Day_Off\=Day,
				slot_Schedule(T,Day,SlotSchedule,Y).
slot_Schedule([ta(Name,_)|T],Day,SlotSchedule,Y):-	
				member(Name,SlotSchedule),
				slot_Schedule(T,Day,SlotSchedule,Y).
slot_Schedule([ta(_,Day_Off)|T],Day,SlotSchedule,Y):-	
				Day_Off=Day,
				slot_Schedule(T,Day,SlotSchedule,Y).	


assign_quiz(quiz(_,Day,Slot,Count),[day(DayName,Slots)|T],Assigned_TAs):-
get_day(Day,[day(DayName,Slots)|T],DaySlots),
S is Slot-1,
nth0(S,DaySlots,Free_TAs),
length(Free_TAs,L),L>=Count,
permutation(Free_TAs,Perm),
cut(Perm,Count,Assigned_TAs).


cut(_,0,[]).
cut([H|T],Count,[H|T1]):-
Count>0,
C is Count-1,
cut(T,C,T1).


get_day(Day,[day(Day,Slots)|_],Slots).

get_day(Day,[day(DayName,_)|T],Slots):-
Day\= DayName,get_day(Day,T,Slots).



assign_quizzes([quiz(Course,Day,Slot,Count)|T],FreeSchedule,ProctoringSchedule):-
get_TAs([quiz(Course,Day,Slot,Count)|T],FreeSchedule,Quizzes_TAs),
get_TAs_info([quiz(Course,Day,Slot,Count)|T],Quizzes_TAs,Quizzes_TAs_info),
checksameSlot(Quizzes_TAs_info),
proctorFormat([quiz(Course,Day,Slot,Count)|T],Quizzes_TAs_info,ProctoringSchedule).

proctorFormat([],_,[]).
proctorFormat([Quizinfo|T],[quizinfo(_,_,_,_,TAs)|T1],[proctors(Quizinfo,TAs)|Tail]):-
proctorFormat(T,T1,Tail).

get_TAs([],_,[]).
get_TAs([quiz(Course,Day,Slot,Count)|T],FreeSchedule,[H|T1]):-
assign_quiz(quiz(Course,Day,Slot,Count),FreeSchedule,H),
get_TAs(T,FreeSchedule,T1).


get_TAs_info([],_,[]).
get_TAs_info([quiz(Course,Day,Slot,Count)|T],[H1|T1],[quizinfo(Course,Day,Slot,Count,H1)|T2]):-
get_TAs_info(T,T1,T2).
				
				
checksameSlot([]).				
checksameSlot([quizinfo(Course,Day,Slot,_,TAs)|T2]	):-
comparewithNext(quizinfo(Course,Day,Slot,_,TAs),T2),
checksameSlot(T2).

comparewithNext(_,[]).
comparewithNext(quizinfo(_,Day,Slot,_,TAs),[quizinfo(_,Day,Slot,_,TAs1)|T]):-
checkUnique(TAs,TAs1),comparewithNext(quizinfo(_,Day,Slot,_,TAs),T).

comparewithNext(quizinfo(_,D,S,_,TAs),[quizinfo(_,Day,_,_,_)|T]):-
D\=Day,comparewithNext(quizinfo(_,D,S,_,TAs),T).

comparewithNext(quizinfo(_,Day,S,_,TAs),[quizinfo(_,Day,Slot,_,_)|T]):-
S\=Slot,comparewithNext(quizinfo(_,Day,S,_,TAs),T).



checkUnique([],_).
checkUnique([H1|T1],L):-
\+member(H1,L),
checkUnique(T1,L).
		