# Projektantrag M223 Recipe Sharing App

## Problemstellung

Ich koche gerne. Ein Problem, welches ich habe ist, dass ich meistens das gleiche koche, weil ich nicht viele Rezepte kenne. Mir fehlt eine zentralisierte Seite, welche es einfach macht, Rezepte zu speichern, teilen und Rezepte von anderen anzusehen.

## Projekt

- Domäne: Ernährung und Gesundheit
- Name: Recipe Sharing App (Working Title)
- Vision: Die App soll als soziale Platform dienen, wo Leute ihre Rezepte teilen können und andere diese anschauen, bewerten oder speichern können. Das ganze könnte man sich ähnlich wie Github, nur mit Rezepten anstatt Code vorstellen

## Projektplanung: 1. MVP Iteration

In der ersten Iteration liegt der Fokus auf der Kernfunktionalität des kollaborativen Rezept-Managements. Dies umfasst das Erstellen, Bearbeiten, Löschen und Suchen von Rezepten, die Abgabe von Bewertungen und Kommentaren sowie die Verwaltung einer persönlichen Favoritensammlung.

## 3. Anforderungsanalyse

### Funktionale Anforderungen (priorisiert)

1. **Benutzerauthentifizierung:** Benutzer können sich registrieren, einloggen, ausloggen und ihr Profil verwalten.
2. **Rezept-CRUD:** Registrierte Benutzer können eigene Rezepte erstellen, anzeigen, bearbeiten und löschen (Titel, Zubereitungszeit, Zutatenliste, Zubereitungsschritte, Status: Entwurf/Veröffentlicht).
3. **Suche & Filterung:** Benutzer können veröffentlichte Rezepte nach Titel und Suchbegriffen durchsuchen sowie nach Schlagwörtern/Tags (z. B. _Vegan_, _Schnell_, _Dessert_) filtern.
4. **Bewertungen & Kommentare:** Registrierte Benutzer können fremde Rezepte einmalig mit 1–5 Sternen bewerten und Kommentare hinterlassen. Kommentare unterstützen Up- und Downvotes.
5. **Persönliche Sammlung (Favoriten):** Registrierte Benutzer können Rezepte per Stern-Symbol zu ihrer persönlichen Favoritensammlung hinzufügen und wieder entfernen.
6. **Zugriffsschutz & Rechteverwaltung:** Nur der jeweilige Autor eines Rezeptes darf dieses bearbeiten oder löschen. Unangemeldete Gäste haben rein lesenden Zugriff auf öffentliche Rezepte.

### Qualitätsattribute (Nicht-funktionale Anforderungen)

1. **Datenkonsistenz bei parallelen Rezensionen:**
    _Konkretisierung:_ Geben zwei Benutzer exakt gleichzeitig eine Rezension (Sterne + Kommentar) für dasselbe Rezept ab, stellt das System durch eine atomare Datenbanktransaktion sicher, dass sowohl die Anzahl der Rezensionen (`review_count`) als auch die Gesamtsumme der Sterne (`rating_sum`) auf der Rezept-Entität korrekt berechnet werden und keine Bewertung verloren geht ("Lost Update").
    
2. **Performance bei der Suche:**
    _Konkretisierung:_ Bei einem Datenbestand von mindestens 2'000 erfassten Rezepten und 15 gleichzeitigen Suchanfragen werden die gefilterten Suchergebnisse (Titel, Tag-Matching, errechneter Sternenschnitt) innerhalb von **maximal 1,5 Sekunden** vollständig im Browser dargestellt.
    
3. **Sicherheit & Autorisierung:**
    _Konkretisierung:_ Jede lesende und schreibende Anfrage an die API wird serverseitig auf die erforderliche Rolle/Berechtigung geprüft. Versucht ein nicht berechtigter Benutzer, ein fremdes Rezept oder eine fremde Rezension per API-Aufruf zu bearbeiten oder zu löschen, verweigert das Backend die Ausführung strikt mit dem HTTP-Statuscode `403 Forbidden`.
    
4. **Benutzerfreundlichkeit & Fehlertoleranz:**
    _Konkretisierung:_ Bei der Fehleingabe von Daten im Rezept- oder Rezensionsformular (z. B. leere Zutatenliste, negative Zubereitungszeit oder keine Sterneauswahl) bleiben alle bereits eingegebenen Formulardaten nach dem Absenden erhalten. Die fehlerhaften Felder werden innerhalb von **unter 300 ms** visuell hervorgehoben und mit einer konkreten Handlungsempfehlung versehen.


### Benutzerrollen
  
- **Gast (Nicht angemeldet):**
    - Kann öffentliche Rezepte suchen, filtern, Detailansichten lesen und Rezensionen anderer Nutzer einsehen.
    - Kann sich registrieren.
        
- **Registrierter Benutzer (Chefkoch / Mitglied):**
    - Besitzt alle Rechte eines Gastes.
    - Kann eigene Rezepte erstellen, bearbeiten, veröffentlichen und löschen.
    - Kann fremde veröffentlichte Rezepte einmalig rezensieren (1–5 Sterne + optionaler Kommentartext) sowie fremde Rezensionen up-/downvoten.
    - Kann Rezepte in der eigenen Favoritensammlung (Stern) speichern und verwalten.
        
- **Administrator / Moderator (Optional):**
    - Kann unsachgemäße Rezensionen oder Richtlinien verletzende Rezepte löschen.

### Locking und Transaktionen
- **Transaktionen:**
    - **Erstellung / Aktualisierung von Rezepten:** Das Speichern eines Rezeptes betrifft mehrere Tabellen (Rezepte, Zutaten, optional Tags). Das Speichern erfolgt innerhalb einer expliziten Datenbanktransaktion. Tritt bei einer Zutat oder einem Tag ein Fehler auf, wird ein vollständiger Rollback ausgeführt, damit keine unvollständigen Rezeptfragmente verbleiben.
        
- **Locking:**
    - **Rezensionsabgabe (Optimistic Locking / Row-Level Locking):** Um bei gleichzeitigem Zugriff mehrerer Benutzer auf dieselbe Rezensionsfunktion "Lost Updates" bei der Berechnung des Notenschnitts zu verhindern, wird beim Aktualisieren des Notenschnitts ein Zeilen-Locking (`SELECT ... FOR UPDATE`) oder Optimistic Locking mittels Versionsspalte auf dem Tabelleneintrag des Rezeptes angewendet.

### ERM

```
Users
- email:string unique
- password:text
- recipes:references, many: Recipes
- comments:references, many: Comments
- favourite:references, one: Favourite

Favourites
- user:references, one: User
- recipes:references, many: Recipes

Recipes
- title:string
- instructions:text
- prep_time_minutes:uint
- is_published:boolean
- ingredents:references, many: Ingredents
- comments:references, many: Comments
- favourites:references, many: Favourites

Ingredents
- name:string
- amount_g:uint, min: 1
- recipe:references, one: Recipe

Comments
- title:string
- body:string optional
- rating:uint, min: 1, max: 5
- recipe:references, one: Recipe
- author:references, one: User
- Constraints:
  - unique (recipe, author)
```

### Breadboards

```
@Recipe List (recipes#index)
  - Sign in / Sign up
    -> @Sign in
  - Go to my favourites
    Not signed in -> @Sign in
    Signed in -> @My Favourites
  - Create new recipe
    Not signed in -> @Sign in
    Signed in -> @New Recipe
  - Search by title (GET recipes#index)
    -> @Recipe List
  - Public recipe cards (title, average rating, ingredient count, prep time)
  - Open recipe
    -> @Recipe Detail

@Recipe Detail (recipes#show)
  - Title, author, instructions, publication status badge
  - Ingredients list (name, amount_g)
  - Back to overview
    -> @Recipe List
  - Toggle favourite (PATCH favourite_recipes#toggle)
    Not signed in -> @Sign in
    Success -> @Recipe Detail
  - Edit recipe (author only)
    -> @Edit Recipe
  - Delete recipe (DELETE recipes#destroy) (author only)
    Success -> @Recipe List
  - Existing comments and ratings list (title, rating, body, author)
  - Add comment & rating (POST comments#create)
    Not signed in -> @Sign in
    Success -> @Recipe Detail
    Already commented -> @Recipe Detail
    Validation error -> @Recipe Detail

@New Recipe (recipes#new)
  - Title, instructions, is_published checkbox
  - Dynamic ingredient rows (name, amount, unit)
  - Save recipe (POST recipes#create)
    Success -> @Recipe Detail
    Validation error -> @New Recipe
  - Cancel
    -> @Recipe List

@Edit Recipe (recipes#edit)
  - Title, instructions, is_published checkbox
  - Manage ingredient rows (add, update, delete name, amount, unit)
  - Update recipe (PATCH recipes#update)
    Success -> @Recipe Detail
    Validation error -> @Edit Recipe
  - Cancel
    -> @Recipe Detail

@My Favourites (favourites#show)
  - List of favorited recipes
  - Open recipe
    -> @Recipe Detail
  - Remove from favourites (DELETE favourite_recipes#destroy)
    Success -> @My Favourites
  - Back to overview
    -> @Recipe List

@Sign in (sessions#new)
  - Email and password inputs
  - Sign in (POST sessions#create)
    Success -> @Recipe List
    Invalid credentials -> @Sign in
  - Go to sign up
    -> @Sign up

@Sign up (registrations#new)
  - Email and password inputs
  - Sign up (POST registrations#create)
    Success -> @Recipe List
    Validation error -> @Sign up
  - Go to sign in
    -> @Sign in
```

### Fat-Marker Sketches

#### Navigation (layout)

![Navigation_Sketch](_assets/Navigation_Sketch.png)

#### Recipe List (recipes#index)

![Recipe_List_Sketch](_assets/Recipe_List_Sketch.png)

#### Recipe Detail (recipes#show)

![Recipe_Detail_Sketch](_assets/Recipe_Detail_Sketch.png)

#### New Recipe (recipes#new)

![New_Recipe_Sketch](_assets/New_Recipe_Sketch.png)

#### Edit Recipe (recipes#edit)

![Edit_Recipe_Sketch](_assets/Edit_Recipe_Sketch.png)

#### My Favourites (favourites#show)

![My_Favourites_Sketch](_assets/My_Favourites_Sketch.png)

#### Sign in (sessions#new)

![Sign_In_Sketch](_assets/Sign_In_Sketch.png)

#### Sign up (registrations#new)

![Sign_Up_Sketch](_assets/Sign_Up_Sketch.png)
