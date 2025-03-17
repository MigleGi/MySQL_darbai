# Kino filmų duomenų bazė

Šiame projekte yra sukurta MySQL duomenų bazė kino filmams analizuoti. 

Projektą sudaro trys pagrindiniai failai:
- **Kino_filmai DB.mwb** – duomenų bazės struktūros modelis, sukurtas naudojant MySQL Workbench.
- **Kino fimų duomenys.sql** – pavyzdiniai duomenys, naudojami duomenų bazei užpildyti testavimo tikslais.
- **Užklausos.sql** – SQL užklausos, skirtos duomenų gavimui ir analizei.

## Projekto turinys

### 1. Duomenų bazės struktūra

Failas `Kino_filmai DB.mwb` apima duomenų bazės schemą su lentelėmis ir jų tarpusavio ryšiais.

### 2. Pavyzdiniai duomenys

Failas `Kino filmų duomenys.sql` pateikia testinius duomenis, kurie gali būti įkelti į duomenų bazę. Tai leidžia išbandyti užklausas ir analizuoti rezultatus be rankinio duomenų įvedimo. 

### 3. SQL užklausos

Failas `Užklausos.sql` apima įvairias užklausas, skirtas duomenų analizavimui ir informacijos gavimui iš duomenų bazės. 

## Kaip naudoti

1. **Duomenų bazės modelio peržiūra**:
   - Atidarykite `Kino_filmai DB.mwb` naudojant MySQL Workbench.
   - Peržiūrėkite lenteles ir ryšius tarp jų.
  
2. **Testinių duomenų įkėlimas**:
   - Norėdami įkelti testinius duomenis, vykdykite `Kino filmų duomenys.sql` skriptą po duomenų bazės struktūros sukūrimo.

2. **Duomenų bazės sukūrimas ir užklausų vykdymas**:
   - Paleiskite MySQL serverį.
   - Atidarykite `Užklausos.sql` savo MySQL Workbench arba kitu SQL redaktoriumi.
   - Vykdykite užklausas norėdami atlikti analizes.

## Reikalavimai
- MySQL Workbench (jei norite peržiūrėti duomenų bazės modelį)
- MySQL serveris (duomenų bazės kūrimui ir užklausų vykdymui)
