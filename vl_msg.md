# Types de Messages de Valgrind

1.    `All heap blocks were freed – no leaks are possible` :

- Positif : Cela signifie que votre programme a libéré toute la mémoire allouée avant de se terminer. Aucune fuite mémoire n’a été détectée.

2.    `Definitely lost` :

- Amélioration nécessaire : Cela signifie qu’il y a une fuite de mémoire certaine. Votre programme a alloué de la mémoire sans la libérer, ce qui consomme des ressources inutilement.

3.    `Indirectly lost` :

- Amélioration nécessaire : Cela signifie qu’il y a une fuite de mémoire liée indirectement à une autre fuite (souvent en raison de structures complexes où la mémoire allouée dans une sou
-structure n’est pas libérée).

4.    `Possibly lost` :

- Amélioration possible : Cela indique que Valgrind soupçonne une fuite mémoire, souvent due à des pointeurs non suivis correctement. Bien que cela ne soit pas nécessairement une erreur critique, il peut être utile de vérifier cette partie du code.

5.    `Still reachable` :

- Neutre, mais améliorable : Il s’agit de mémoire allouée que le programme n’a pas libérée mais qui reste accessible. Si cette mémoire aurait pu être libérée proprement, cela peut être amélioré pour de meilleures pratiques.

6.    `Invalid read` || `Invalid write` :

- Urgent : Cela signifie que votre programme essaie de lire ou écrire dans une zone mémoire non allouée (par exemple, une lecture après la fin d’un tableau). Ces erreurs peuvent provoquer des plantages et des comportements imprévisibles.

7.    `Invalid free` :

- Urgent : Cela signifie que votre programme tente de libérer un espace mémoire qui n’a pas été alloué avec malloc ou qui a déjà été libéré. Cela peut corrompre la mémoire.

8.    `Conditional jump or move depends on uninitialised value(s)` :

- Amélioration nécessaire : Cela signifie que votre programme utilise des valeurs non initialisées dans une condition, ce qui peut entraîner un comportement indéterminé.