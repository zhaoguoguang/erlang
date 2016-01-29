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
%OR是单引号
or_([H|T])->      % 请看，rule和or_都是一个输入为N，输出为{true,Acc}或false的函数。这是OR的组合模式思想。这样OR的结果才可以进一步组合。其实他们都是函数（或映射），OR的返回结果和H都是一样的一个函数，类型相同。
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
		{true,HAcc} -> (myAnd(T,OP,OP(Acc,HAcc)))(N);  %%%%%% 注意不要忘记把这个N传给下一个函数。★★★★★★★★★★★★★
		false       -> false
	    end
	end. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
