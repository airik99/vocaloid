vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).
vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).
vocaloid(kaito, cancion()).

% predicados extra para pruebas
/*vocaloid(facondo, cancion(aa, 3)).
vocaloid(airik, cancion(hola, 9)).
vocaloid(airik, cancion(chau, 7)).
vocaloid(airik, cancion(aaa, 7)).*/

% ------------ PUNTO 1 ------------

esNovedoso(Vocaloid) :-
    vocaloid(Vocaloid, _),
    cantidadDeCanciones(Vocaloid, CantidadCanciones),
    duracionTotalDeCanciones(Vocaloid, DuracionTotal),
    DuracionTotal =< 15,
    CantidadCanciones >= 2.

cantidadDeCanciones(Vocaloid, CantidadCanciones) :-
    findall(Cancion, vocaloid(Vocaloid, cancion(Cancion, _)), Canciones),
    length(Canciones, CantidadCanciones).


duracionTotalDeCanciones(Vocaloid, DuracionTotal) :-
    findall(Duracion, vocaloid(Vocaloid, cancion(_, Duracion)), Duraciones),
    sum_list(Duraciones, DuracionTotal).

cantante(Vocaloid) :-
    vocaloid(Vocaloid, cancion(_, _)).

% ------------ PUNTO 2 ------------

esAcelerado(Vocaloid) :-
    cantante(Vocaloid),
    not((vocaloid(Vocaloid, cancion(_, Duracion)), not(Duracion =< 4))).

% ------------ CONCIERTOS ------------
% ------------ PUNTO 1 ------------

concierto(mikuExpo, estadosUnidos, 2000, tipoConcierto(gigante, 2, 6)).
concierto(magicalMirai, japon, 3000, tipoConcierto(gigante, 3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, tipoConcierto(mediano, 9)).
concierto(mikuFest, argentina, 100, tipoConcierto(pequenio, 4)).

% ------------ PUNTO 2 ------------

puedeParticipar(Vocaloid, Concierto) :-
    concierto(Concierto, _, _, _),
    puedeParticiparEnElConcierto(Vocaloid, Concierto).

puedeParticiparEnElConcierto(hatsuneMiku, _).

puedeParticiparEnElConcierto(Vocaloid, Concierto) :-
    vocaloid(Vocaloid, _),
    Vocaloid \= hatsuneMiku,
    concierto(Concierto, _, _, TipoConcierto),
    cumpleLosRequisitosParaElConcierto(Vocaloid, TipoConcierto).

cumpleLosRequisitosParaElConcierto(Vocaloid, tipoConcierto(gigante, CantidadMinima, DuracionTotalMinima)) :-
    cantidadDeCanciones(Vocaloid, CantidadCanciones),
    duracionTotalDeCanciones(Vocaloid, DuracionTotal),
    CantidadCanciones >= CantidadMinima,
    DuracionTotal >= DuracionTotalMinima.

cumpleLosRequisitosParaElConcierto(Vocaloid, tipoConcierto(mediano, DuracionTotalMaxima)) :-
    duracionTotalDeCanciones(Vocaloid, DuracionTotal),
    DuracionTotal =< DuracionTotalMaxima.

cumpleLosRequisitosParaElConcierto(Vocaloid, tipoConcierto(pequenio, DuracionMinimaDeCancion)) :-
    vocaloid(Vocaloid, cancion(_, Duracion)),
    Duracion >= DuracionMinimaDeCancion.

% ------------ PUNTO 3 ------------

elMasFamoso(UnVocaloid) :-
    nivelDeFama(UnVocaloid, NivelFama1),
    forall(nivelDeFama(_, NivelFama2), NivelFama1 >= NivelFama2).

nivelDeFama(Vocaloid, NivelFama) :-
    vocaloid(Vocaloid, _),
    cantidadDeCanciones(Vocaloid, CantidadCanciones),
    findall(Fama, famaPorConcierto(Vocaloid, Fama), FamaConciertos),
    sum_list(FamaConciertos, FamaTotal),
    NivelFama is FamaTotal * CantidadCanciones.

famaPorConcierto(Vocaloid, NivelFama) :-
    puedeParticipar(Vocaloid, Concierto),
    concierto(Concierto, _, NivelFama, _).

% ------------ PUNTO 4 ------------

conoceA(megurineLuka, hatsuneMiku).
conoceA(megurineLuka, gumi).
conoceA(gumi, seeU).
conoceA(seeU, kaito).

conoce(UnVocaloid, OtroVocaloid) :-
    conoceA(UnVocaloid, OtroVocaloid).

conoce(UnVocaloid, OtroVocaloid) :-
    conoceA(UnVocaloid, Conocido),
    conoce(Conocido, OtroVocaloid).

participaSolo(Vocaloid, Concierto) :-
    puedeParticipar(Vocaloid, Concierto),
    not((conoce(Vocaloid, OtroVocaloid), puedeParticipar(OtroVocaloid, Concierto))).

% ------------ PUNTO 5 ------------

% Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, 
% explique los cambios que habría que realizar para que siga todo funcionando. ¿Qué conceptos facilitaron dicha implementación?

% deberiamos agregar otro predicado llamado cumpleLosRequisitosParaElConcierto, que tenga las condiciones que se necesitan para que se pueda participar en el concierto,
% como en el predicado cumpleLosRequisitosParaElConcierto utilizamos polimorfimos, basta con agregar el functor con los requisitos del nuevo tipo