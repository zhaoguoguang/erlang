-module(fizz). 
-export([start/0]). 

start() ->
	io:format("~p~n",[[speaknumber(N) || N <- lists:seq(1,105)]]),
	{MegaSecs, Secs, MicroSecs} = erlang:now(), 
	[speaknumber(N) || N <- lists:seq(1,100000)],
	{MegaSecsL, SecsL, MicroSecsL} = erlang:now(), 
	io:format("erlang 100000 time is ~p~n",[[MegaSecsL - MegaSecs, SecsL-Secs,MicroSecsL-MicroSecs]]). 

%============================================================

spec(N) ->
	Times3 = times_(3),
	IsTimes3 = Times3(N),
	if
  		IsTimes3 andalso N rem 5 =:= 0 andalso N rem 7 =:= 0 -> "fizzbizzwhizz";
		N rem 3 =:= 0 andalso N rem 5 =:= 0  -> "fizzbizz";
		N rem 5 =:= 0 andalso N rem 7 =:= 0 -> "bizzwhizz";
		N rem 3 =:= 0 andalso N rem 7 =:= 0 -> "fizzwhizz";		
		N rem 3 =:= 0 -> "fizz";
		N rem 5 =:= 0 -> "bizz";
		N rem 7 =:= 0 -> "whizz";
		true          -> integer_to_list(N)
	end. 

speaknumber(N)->
	Rule3 = rule(times_(3),fun(_) -> "fizz" end ),
	Rule5 = rule(times_(5),fun(_) -> "bizz" end ),
	Rule7 = rule(times_(7),fun(_) -> "whizz" end ),	
	RuleAll = rule(fun(_)->true end,fun(X) -> X end ),
	Final = or_([ and_([Rule3,Rule5,Rule7])
			 ,and_([Rule3,Rule5])
			 ,and_([Rule3,Rule7])
			 ,and_([Rule5,Rule7])
			 ,or_([Rule3,Rule5,Rule7,RuleAll])]),
	case Final(N) of
		{true,Acc} -> Acc;
		false      -> "*"
	end. 

times_(N) ->
	fun(X)->( X rem N =:= 0 ) end. 

%rule(Pred,Action)->
%	fun(N) ->
%            IsPred = Pred(N),
%	    if
%		IsPred -> {true,Action()};
%		true   -> false
%	    end
%	end. 
rule(Pred,Action)-> %
	fun(N)->
	    case Pred(N) of
		true  -> {true,Action(N)};
		false -> false
	    end
	end. 
%OR�ǵ�����
or_([H|T])->      % �뿴��rule��or_����һ������ΪN�����Ϊ{true,Acc}��false�ĺ���������OR�����ģʽ˼�롣����OR�Ľ���ſ��Խ�һ����ϡ���ʵ���Ƕ��Ǻ�������ӳ�䣩��OR�ķ��ؽ����H����һ����һ��������������ͬ��
 	fun(N)->
	    case H(N) of
	        {true,Acc} -> {true,Acc};
		false      -> (or_(T))(N)
	    end
	end. 

and_(L)->
 	myAnd(L,fun(A,B)-> string:concat(A,B) end, ""). 

myAnd([],_,Acc)  -> 
	fun(_) -> {true,Acc} end ;
myAnd([H|T],OP,Acc)->
	fun(N)->
	    case H(N) of
		{true,HAcc} -> (myAnd(T,OP,OP(Acc,HAcc)))(N);  %%%%%% ע�ⲻҪ���ǰ����N������һ����������������������
		false       -> false
	    end
	end. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
