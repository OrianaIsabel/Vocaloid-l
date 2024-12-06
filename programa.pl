% Aquí va el código.
vocaloid(megurineLuka).
vocaloid(hatsuneMiku).
vocaloid(gumi).
vocaloid(seeU).
vocaloid(kaito).

sabeCantar(megurineLuka, cancion(nightFever, 4)).
sabeCantar(megurineLuka, cancion(foreverYoung, 5)).
sabeCantar(hatsuneMiku, cancion(tellYourWorld, 4)).
sabeCantar(gumi, cancion(foreverYoung, 4)).
sabeCantar(gumi, cancion(tellYourWorld, 5)).
sabeCantar(seeU, cancion(novemberRain, 6)).
sabeCantar(seeU, cancion(nightFever, 5)).

% Punto 1

seSabeVarias(Vocaloid):-
    sabeCantar(Vocaloid, Cancion1),
    sabeCantar(Vocaloid, Cancion2),
    Cancion1 \= Cancion2.

duracionTotal(Vocaloid, Total):-
    findall(Duracion, sabeCantar(Vocaloid, cancion(_, Duracion)), Duraciones),
    sumlist(Duraciones, Total).

esNovedoso(Vocaloid):-
    vocaloid(Vocaloid),
    seSabeVarias(Vocaloid),
    duracionTotal(Vocaloid, Duracion),
    Duracion < 15.

% Punto 2

duracion(cancion(_, Duracion), Duracion).

cantaCancionLarga(Vocaloid):-
    sabeCantar(Vocaloid, Cancion),
    duracion(Cancion, Duracion),
    Duracion > 4.

esAcelerado(Vocaloid):-
    vocaloid(Vocaloid),
    not(cantaCancionLarga(Vocaloid)).

% Punto 3

concierto(mikuExpo, eeuu, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequeno(4)).

cuantasCanta(Vocaloid, Cantidad):-
    findall(Cancion, sabeCantar(Vocaloid, Cancion), Canciones),
    length(Canciones, Cantidad).

cumpleRequisitos(Vocaloid, Concierto):-
    concierto(Concierto,_,_, gigante(CantMin, DurMin)),
    cuantasCanta(Vocaloid, Canciones),
    Canciones >= CantMin,
    duracionTotal(Vocaloid, Duracion),
    Duracion >= DurMin.

cumpleRequisitos(Vocaloid, Concierto):-
    concierto(Concierto,_,_, mediano(DurMax)),
    duracionTotal(Vocaloid, Duracion),
    Duracion < DurMax.

cumpleRequisitos(Vocaloid, Concierto):-
    concierto(Concierto,_,_, pequeno(DurMin)),
    sabeCantar(Vocaloid, cancion(_, Duracion)),
    Duracion > DurMin.

puedeParticipar(Vocaloid, Concierto):-
    vocaloid(Vocaloid),
    cumpleRequisitos(Vocaloid, Concierto).

puedeParticipar(hatsuneMiku,_).

% Punto 4

famaQueDa(Concierto, Fama):-
    concierto(Concierto,_,Fama,_).

famaTotal(Vocaloid, FamaTotal):-
    findall(Fama, (puedeParticipar(Vocaloid, Concierto), famaQueDa(Concierto, Fama)), ListaFama),
    sumlist(ListaFama, FamaTotal).

nivelDeFama(Vocaloid, Nivel):-
    famaTotal(Vocaloid, Fama),
    cuantasCanta(Vocaloid, Canciones),
    Nivel is Fama * Canciones.

masFamoso(Vocaloid):-
    vocaloid(Vocaloid),
    nivelDeFama(Vocaloid, Nivel),
    forall((vocaloid(Otro), Otro \= Vocaloid, nivelDeFama(Otro, OtroNivel)), Nivel >= OtroNivel).

% Punto 5

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

esConocido(Vocaloid1, Vocaloid2):-
    conoce(Vocaloid1, Vocaloid2).

esConocido(Vocaloid1, Vocaloid2):-
    conoce(Otro, Vocaloid2),
    esConocido(Vocaloid1, Otro).

participaSolo(Vocaloid, Concierto):-
    vocaloid(Vocaloid),
    puedeParticipar(Vocaloid, Concierto),
    forall((vocaloid(Otro), esConocido(Vocaloid, Otro)), not(puedeParticipar(Otro, Concierto))).
    