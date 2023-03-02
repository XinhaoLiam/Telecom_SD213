/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 4044                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/* Adapted by Kaixuan Zhu, Xinhao Li                             */
/*---------------------------------------------------------------*/



% a little more sophisticated elementary English grammar

% --- Productions rules

s --> s,conj,s.     %Two simple sentences connected with a conjunction.
s--> np(FS1),vp([subj:FS1|_]).

%This part is for the order of Personal Pronoun
np([number:1, person:2,is_person:1]) --> np([number:1, person:2,is_person:1]), conj_or, np([number:_, person:_,is_person:_]). %you or ...
np([number:max(Num,1), person:1,is_person:1]) --> np([number:Num, person:_,is_person:_]), conj_or, np([number:1, person:1,is_person:1]). %... or i
np([number:max(Num1,Num2), person:3,is_person:max(Ip1,Ip2)]) --> np([number:Num1, person:3,is_person:Ip1]), conj_or, np([number:Num2, person:3,is_person:Ip2]). %Other situations

np([number:2, person:2,is_person:1]) --> np([number:1, person:2,is_person:1]), conj_and, np([number:_, person:_,is_person:_]). %you and ...
np([number:2, person:1,is_person:1]) --> np([number:_, person:_,is_person:_]), conj_and, np([number:1, person:1,is_person:1]). %... and i
np([number:2, person:3,is_person:Ip1*Ip2]) --> np([number:_, person:3,is_person:Ip1]), conj_and, np([number:_, person:3,is_person:Ip2]). %Other situation

np([number:2, person:1,is_person:_]) --> np([number:2, person:1,is_person:1]), conj_or, np([number:_, person:_,is_person:_]). %we or ...
np([number:2, person:Person1,is_person:1]) --> np([number:_, person:Person1,is_person:1]), conj_or, np([number:2, person:3,is_person:_]). % ... or they

np([number:2, person:1,is_person:_]) --> np([number:2, person:1,is_person:1]), conj_and, np([number:2, person:_,is_person:_]). %we and ...
np([number:2, person:Person1,is_person:1]) --> np([number:2, person:Person1,is_person:1]), conj_and, np([number:2, person:3,is_person:_]). %... and they

%Personal Pronoun don't need "The"
np([number:Num, person:1,is_person:1]) --> n([number:Num,person:1,is_person:1]). %For i & we
np([number:Num, person:2,is_person:1]) --> n([number:Num,person:2,is_person:1]). %For you & you

%Normal case
np(FS) --> det(FS), n(FS), attri_ss(FS).		% Simple noun phrase + attributive clause
np(FS) --> det(FS), n(FS).		                % Simple noun phrase
np(FS) --> np(FS), pp.		                    % Noun phrase + prepositional phrase 
np(FS) --> osb_ss(FS).                          % Sub-clause as a noun phrase (object clause, subject clause)

%Relative clause Frame
attri_ss(FS) --> attri_conj,np(FS1),ss_vp([subj:FS1|_]).  % A simple attributive clause : that I like 
attri_ss(FS) --> attri_conj,vp([subj:FS|_]).            % A simple attributive clause : that hates the dog 
osb_ss([number:1,person:3,is_person:Isp]) --> osb_conj([is_person:Isp]), np(FS),ss_vp([subj:FS|_]).   
														% A simple object/subject clause : that I like 
osb_ss([number:Num,person:Person, is_person:Isp]) --> osb_conj([is_person:Isp]), vp([subj:[number:Num,person:Person,is_person:Isp]|_]).       
														% A simple object/subject clause : that likes the dog 
%Verb phrase for relative clause
ss_vp([subj:FS,transitive:1]) --> v([subj:FS,transitive:1]).            % transitive verb
ss_vp([subj:FS,transitive:0]) --> v([subj:FS,transitive:0]), p.         % verb + prep : that I think of.
ss_vp([subj:FS,transitive:1]) --> v([subj:FS,transitive:1]), np(_), p.  % verb + complement + prep : that I give the book to.
ss_vp([subj:FS,transitive:1]) --> v([subj:FS,transitive:1]), pp.        % verb + complement + prep : that I give to Mary.
ss_vp([subj:FS,transitive:0]) --> v([subj:FS,transitive:0]), p, pp.     % verb + prep + indirect complement : that I talk to about sth.
ss_vp([subj:FS,transitive:0]) --> v([subj:FS,transitive:0]), pp, p.     % verb + indirect complement + prep : that I talk to sb about.

%Verb phrase for normal sentences
vp([subj:FS|T]) --> vp([subj:FS|T]), conj, vp([subj:FS|_]).             % Two verb phrases with conjuction
vp([subj:FS,transitive:0]) --> v([subj:FS,transitive:0]).               % intransitive verb
vp([subj:FS,transitive:1]) --> v([subj:FS,transitive:1]), np(_).		% verb + complement:  like X
vp([subj:FS,transitive:0]) --> v([subj:FS,transitive:0]), pp.		    % verb + indirect complement : think of X 
vp([subj:FS,transitive:1]) --> v([subj:FS,transitive:1]), np(_), pp.	% verb + complement + indirect complement : give X to Y 
vp([subj:FS,transitive:0]) --> v([subj:FS,transitive:0]), pp, pp.	    % verb + indirect complement + indirect complement : talk to X about Y

%Prep phrases
pp --> pp, conj, pp.    % two prepositional phrases connected with a conjunction
pp --> p, np(_).		% prepositional phrase

% -- Lexicon
% det part
det([number:_, person:_,is_person:_]) --> [the].
det([number:_, person:_,is_person:_]) --> [my].
det([number:_, person:_,is_person:_]) --> [her].
det([number:_, person:_,is_person:_]) --> [his].
det([number:1, person:_,is_person:_]) --> [a].
det([number:2, person:_,is_person:_]) --> [some].

% noun part
n([number:1, person:1,is_person:1]) --> [i].
n([number:2, person:1,is_person:1]) --> [we].

n([number:1, person:2,is_person:1]) --> [you].
n([number:2, person:2,is_person:1]) --> [you].

n([number:1, person:3,is_person:0]) --> [dog].
n([number:2, person:3,is_person:0]) --> [dogs].

n([number:1, person:3,is_person:1]) --> [daughter].
n([number:2, person:3,is_person:1]) --> [daughters].

n([number:1, person:3,is_person:1]) --> [son].
n([number:2, person:3,is_person:1]) --> [sons].

n([number:1, person:3,is_person:1]) --> [sister].
n([number:2, person:3,is_person:1]) --> [sisters].

n([number:1, person:3,is_person:1]) --> [aunt].
n([number:2, person:3,is_person:1]) --> [aunts].

n([number:1, person:3,is_person:1]) --> [neighbour].
n([number:2, person:3,is_person:1]) --> [neighbours].

n([number:1, person:3,is_person:1]) --> [cousin]. 
n([number:2, person:3,is_person:1]) --> [cousins].

% verb part
v([subj:[number:1, person:1,is_person:_],transitive:0]) --> [grumble].
v([subj:[number:1, person:2,is_person:_],transitive:0]) --> [grumble].
v([subj:[number:1, person:3,is_person:_],transitive:0]) --> [grumbles].
v([subj:[number:2, person:1,is_person:_],transitive:0]) --> [grumble].
v([subj:[number:2, person:2,is_person:_],transitive:0]) --> [grumble].
v([subj:[number:2, person:3,is_person:_],transitive:0]) --> [grumble].

v([subj:[number:1, person:1,is_person:_],transitive:1]) --> [like].
v([subj:[number:1, person:2,is_person:_],transitive:1]) --> [like].
v([subj:[number:1, person:3,is_person:_],transitive:1]) --> [likes].
v([subj:[number:2, person:1,is_person:_],transitive:1]) --> [like].
v([subj:[number:2, person:2,is_person:_],transitive:1]) --> [like].
v([subj:[number:2, person:3,is_person:_],transitive:1]) --> [like].

v([subj:[number:1, person:1,is_person:_],transitive:1]) --> [give].
v([subj:[number:1, person:2,is_person:_],transitive:1]) --> [give].
v([subj:[number:1, person:3,is_person:_],transitive:1]) --> [gives].
v([subj:[number:2, person:1,is_person:_],transitive:1]) --> [give].
v([subj:[number:2, person:2,is_person:_],transitive:1]) --> [give].
v([subj:[number:2, person:3,is_person:_],transitive:1]) --> [give].

v([subj:[number:1, person:1,is_person:_],transitive:0]) --> [talk].
v([subj:[number:1, person:2,is_person:_],transitive:0]) --> [talk].
v([subj:[number:1, person:3,is_person:_],transitive:0]) --> [talks].
v([subj:[number:2, person:1,is_person:_],transitive:0]) --> [talk].
v([subj:[number:2, person:2,is_person:_],transitive:0]) --> [talk].
v([subj:[number:2, person:3,is_person:_],transitive:0]) --> [talk].

v([subj:[number:1, person:1,is_person:1],transitive:1]) --> [annoy].
v([subj:[number:1, person:2,is_person:1],transitive:1]) --> [annoy].
v([subj:[number:1, person:3,is_person:1],transitive:1]) --> [annoys].
v([subj:[number:2, person:1,is_person:1],transitive:1]) --> [annoy].
v([subj:[number:2, person:2,is_person:1],transitive:1]) --> [annoy].
v([subj:[number:2, person:3,is_person:1],transitive:1]) --> [annoy].

v([subj:[number:1, person:1,is_person:1],transitive:1]) --> [think].
v([subj:[number:1, person:2,is_person:1],transitive:1]) --> [think].
v([subj:[number:1, person:3,is_person:1],transitive:1]) --> [thinks].
v([subj:[number:2, person:1,is_person:1],transitive:1]) --> [think].
v([subj:[number:2, person:2,is_person:1],transitive:1]) --> [think].
v([subj:[number:2, person:3,is_person:1],transitive:1]) --> [think].

v([subj:[number:1, person:1,is_person:_],transitive:1]) --> [hate].
v([subj:[number:1, person:2,is_person:_],transitive:1]) --> [hate].
v([subj:[number:1, person:3,is_person:_],transitive:1]) --> [hates].
v([subj:[number:2, person:1,is_person:_],transitive:1]) --> [hate].
v([subj:[number:2, person:2,is_person:_],transitive:1]) --> [hate].
v([subj:[number:2, person:3,is_person:_],transitive:1]) --> [hate].

v([subj:[number:1, person:1,is_person:_],transitive:0]) --> [cry].
v([subj:[number:1, person:2,is_person:_],transitive:0]) --> [cry].
v([subj:[number:1, person:3,is_person:_],transitive:0]) --> [cries].
v([subj:[number:2, person:1,is_person:_],transitive:0]) --> [cry].
v([subj:[number:2, person:2,is_person:_],transitive:0]) --> [cry].
v([subj:[number:2, person:3,is_person:_],transitive:0]) --> [cry].

v([subj:[number:1, person:3,is_person:0],transitive:0]) --> [barks].
v([subj:[number:2, person:3,is_person:0],transitive:0]) --> [bark].

% conjunction part
conj_and --> [and]. %% conjunction for people
conj_or --> [or].

conj --> [and].     %% conjuction for verbs/sentences
conj --> [or].
conj --> [but].

attri_conj --> [that].

osb_conj([is_person:1]) --> [who].
osb_conj([is_person:0]) --> [what].

%prep part
p --> [of].
p --> [to].
p --> [about].
p --> [at].