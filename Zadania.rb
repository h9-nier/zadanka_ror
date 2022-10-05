module Example

    # Napisz metodę która dla dowolnych dwóch liczb zwróci procentową wartość jeden z liczb względem drugiej
    def self.percent(total, value)
        if total < value
            return total*100.0/value
        else 
            return value*100.0/total
        end
    end

    def self.reverse_long_words(string)
        # Uzupełnij metodę reverse_long_words(string).
        # Metoda ta odwraca każdy wyraz o znakach 5 lub więcej i zwraca całość
        # do użytkownika.
        # Na przykład
            # INPUT : "Ala ma kotozaura wiec jest okejson"
            # OUTPUT : "Ala ma aruazotok wiec jest nosjeko"
        string_arr = string.split(' ')


        string_arr.each do |letter|
            if letter.length > 4
                print letter.reverse + " "
            else
                print letter + " "
            end
        end
    end

    def split_number(number)
        # Uzupełnij metodę split_number(number). Metoda ta ma podzielić liczbę
        # na jedności, dziesiątki, setki itd... i wyświetlić je w postaci dodawania. # NP 12 => 10 + 2 ; 125 => 100 + 20 + 5. 1056 => 1000 + 50 + 6.
        # Uwaga. Należy zwrócić uwagę by nie wyświetlać w dodawaniu + 0, gdy
        # jedna z części jest równa zeru. 

        char_arr = number.to_s.split('')
        #rozdzielamy liczbę na tablicę znaków

        n = number.to_s.length
        #liczymy długość tablicy
        
        counter = 10**(n-1)
        #licznik słuzący do mnozenia cyfry

        puts "#{number} => #{char_arr[0].to_i*counter}"
        char_arr.shift
        counter /= 10
        #drukujemy pierwszą cyfrę pomnozoną przez odpowiednią potęgę dziesiątki, po czym usuwamy ją z listy
        
        char_arr.each do |char|
            if char == '0'
                counter /= 10
                next
            end
            puts " + #{char.to_i*counter}"
            counter /= 10
        end
        #wynokujemy to samo dla reszty tablicy, pomijająć zera

        puts
    end

    def alphabet_position(text)
        # Napisz metode która dla podanego tekstu zwróci pozycje kazdej litery
        # w alfabecie
        # Jeśli coś nie jest literą zignoruj to i pomiń
        # Przykład
        # alphabet_position("To jest test metody")
        # "20 15 10 5 19 20 20 5 19 20 13 5 20 15 4 25" # alphabet_position("123--")
        # ""

        alphabet = "abcdefghijklmnopqrstuvwxyz".split('')
        char_arr = text.split('')
        #rozdzielamy tekst na tablicę znaków

        char_arr.each do |char|
            if !alphabet.include?(char.downcase) || char == ' '
                next
                #jeśli znak nie nalerzy do zadeklarowanego alfabetu, pomijamy pętlę
            else
                num = alphabet.find_index(char.downcase)
                puts "#{num.to_i+1} "
                #jesli znak nalerzy do zadeklarowanego alfabetu, wyświetlamy jego indeks w talicy
            end
        end


        puts
    end

end

include Example

# Przedstawiona jest klasa Patient. Wskaż błędy.
class Patient

    def initialize(id:, first_name = nil, last_name: nil)
    #powinno być 
    #def initialize(id, first_name = nil, last_name = nil)
        @id = id
        @firstName = first_name 
        @last_name = last_name
        #lepiej aby nazewnictwo było konsekwentne, czyli:
        # @first_name i @last_name
    end
    
    def self.patient?(id) 
    #powinno być bez self, jeśli chcemy się odwołać jak w przykładach ponizej
    # self pozwala nam się odwołać do klasy, nie wymagając objektu
        id != @id
    end

    def full_name 
        firstName + last_name
        #powinno być
        #@firstName + @lastName
        #jako e firstName i last_name to zmienne lokalne
    end 
end


patient_1 = Patient.new(id: "123") 
#tworzy nowy obiekt id: "123", first_name: nil, last_name: nil
patient_1.patient?("123") 
# => false
patient_1.full_name
# zwraca błąd, jako ze nasz @firstName i @last_name to nil

patient_2 = Patient.new("Karol", "Tychek") 
#błąd, kolejność argumentów powinna odpowiadać kolejności parametrów
patient_2.patient?("123") 
# => true
patient_2.full_name
# zwraca błąd, przez złe utworzenie obiektu

patient_3 = Patient.new(id: "123", first_name: "Roman") 
patient_3.patient?("Roman") 
# => true, ale metoda nie spełnia swojego zadania
# nie ma sensu porównywać first_name do id
patient_3.full_name
# zwraca błąd, jako ze nie mozna zsumować string i nil


# W aplikacji zostały zdefiniowane następujące modele
# Napisz serwis, który:
# 1. Przyjmie w paramterach numer strony i limit na stronę
# 2. Ograniczy maksymalny limit do 100
# 3. Wyciągnie tylko opublikowane posty i posortuje je malejąco po dacie publikacji
# 4. Zwróci hash o podanej strukturze:
# - id, tytuł i treść posta,
# - kolekcje komentarzy: id, body i imię i naziwsko autora ( bez komentarzy oznaczonych jako usuniete )

class SampleService
    
    # konstruktor serwisu
    def initialize(page:, items_per_page:)
        @page = page
        @items_per_page = items_per_page
    end


    attr_reader :page, :items_per_page

    # funkcja w której dzieje się to co ma robić serwis
    def call

        #sprawdzamy czy limit nie przekracza 100
        if @items_per_page > 100
            @items_per_page = 100
        end

        #wyciągamy items_per_page opublikowanych postów i sortujemy je malejąco po dacie
        published_posts = Post.where.not(published_at: [nil, ""]).limit(@items_per_page).order(published_at: :desc)

        #tymczasowo przechwyowuje komentarze nalezące do pojedynczego postu
        posts_comments = Array.new

        #przechowywuje hashe postów do zwrócenia
        all_posts = Array.new

        #pętla iterująca po opublikowanych postach
        published_posts.each do |post|

            #pętla iterująca po wszystkich komentarzach pojedynczego postu
            post.comments.each do |comment|

                #sprawdzamy czy komentarz został usunięty
                next if comment.removed == true

                #jeśli komentarz nie został usunięty, dodajemy go do listy komentarzy pojedynczego postu
                posts_comments.append(
                    {
                        id: comment.id,
                        body: comment.body,
                        author_first_name: comment.author.first_name,
                        author_last_name: comment.author.last_name
                    }
                )
            end

            all_posts.append(
                {
                    post: {id: post.id,
                           title: post.title,
                           body: post.body},
                    comments: posts_comments
                }
            )

            #czyścimy listę, szykując ją do następnej iteracji
            posts_comments.clear()
        end

        return all_posts
    end

end