#Homework 2 asks you to write a program that will find the area underneath a curve. This is a problem that many great mathematicians spent many years trying to figure out in the 17th century. Isaac Newton derived integral calculus to solve this problem because there were no machines to help him at the time. We will take a more mechanical approach.

#The input to the program will be a function. For example:

#f(x) = x^2

#is a function that can be graphed on a Cartesian plane.

#Your job is to store the representation of a function in your program. Then, in order to find the area underneath the curve you must ask the user for the two bounds of the curve that you want to find the area underneath.

#For example, one might want to find the area underneath the curve f(x) = x^2 from 0 to 2 (the answer is 8/3).

#After storing the function and the bounds it is up to you to come up with an approximation of the area underneath the curve. Use struct's to store the function information.

#The approximate area underneath the curve f(x) = x^2 + 2x + 4 from 1 to 3 is 24.6666.
#The approximate area underneath the curve f(x) = 5x + 5 from 0 to 2 is 20.

#The program should prompt the user for a formula with an unlimited number of terms. Store the terms in a vector and manipulate the vector.

#Here are a few sample runs of the program:
#Example 1
#Enter the coefficient for term 1: 1
#Enter the exponent for term 1: 2
#Do you have more terms to enter (y or n): n

#Enter the lower bound: 0
#Enter the upper bound: 2

#The area underneath the curve f(x) = x^2 from 0 to 2 is about 2.66669
#Press any key to continue

#Example 2 
#Enter the coefficient for term 1: 1
#Enter the exponent for term 1: 2
#Do you have more terms to enter (y or n): y

#Enter the coefficient for term 2: 2
#Enter the exponent for term 2: 1
#Do you have more terms to enter (y or n): y

#Enter the coefficient for term 3: 4
#Enter the exponent for term 3: 0
#Do you have more terms to enter (y or n): n

#Enter the lower bound: 1
#Enter the upper bound: 3

#The area underneath the curve f(x) = x^2 + 2x + 4
#from 1 to 3 is about 24.6668
#Press any key to continue


#Example 3 
#Enter the coefficient for term 1: 5
#Enter the exponent for term 1: 1
#Do you have more terms to enter (y or n): y

#Enter the coefficient for term 2: 5
#Enter the exponent for term 2: 0
#Do you have more terms to enter (y or n): n

#Enter the lower bound: 0
#Enter the upper bound: 2

#The area underneath the curve f(x) = 5x + 5
#from 0 to 2 is about 20.0001
#Press any key to continue


defmodule Calculus do

    IO.puts "Welcome to the Riemann Sum Calculator \n implemented in the amazing Elixir lang!!!\n"

    @divider 50000

    defp parseTerm (term) do
        if (String.contains?(term, ".")) do
            String.to_float(term)
        else
            String.to_integer(term)
        end
    end

    defp takeTerms(terms) do

        c1 = IO.gets "Enter in the Coefficient: "
        c2 = String.slice(c1, 0, String.length(c1) - 1)
        coefficient = parseTerm(c2)

        e1 = IO.gets "Enter in the Exponent: "
        e2 = String.slice(e1, 0, String.length(e1) - 1)
        exponent = String.to_integer(e2)
        
        r = IO.gets "Continue Entering Terms? (Y/N):"
        response = String.slice(r, 0, String.length(r) - 1)
        
        #turn into list of lists: [[1, 2], [2, 3], [3, 4]]
        #use head and tail to manipulate each pair of terms
        
        #addedCo = List.insert_at(listOfCo, length(listOfCo), coefficient)
        #addedEx = List.insert_at(listOfEx, length(listOfEx), exponent)
        
        newTerm = [coefficient, exponent]
        
        updatedList = List.insert_at(terms, length(terms), newTerm)
        
        cond do
            response == "y" ->
                takeTerms(updatedList)
            response == "n" ->
                updatedList
        end     
    end
    
    #defp makeRange(current, goal, hopVal, list) do
    #    
    #    #use Enum map on for 1..@divider x * width
    #
    #    if current >= goal do
    #        list
    #    else
    #        newCurrent = current + hopVal
    #        updatedList = List.insert_at(list, length(list), newCurrent)
    #        makeRange(newCurrent, goal, hopVal, updatedList)
    #    end
    #    
    #end   
    
    defp heightFinder(currentTotal, xVal, termsList) do
        
        if [] == termsList do
            currentTotal
        else
            [head | tail] = termsList
            [co | exponent] = head
            [ex | _] = exponent
            thisTerm = :math.pow(xVal, ex) * co
            heightFinder(currentTotal + thisTerm, xVal, tail)
        end
        
    end
    
    defp makeRect(xVal, width, termsList) do
        
        #[m, n]
        #for [m, n] <- allTerms do 
           #IO.puts :lists.nth(1, m) #erlang is 1 based
        #end
        
        height = heightFinder(0, xVal, termsList)
        height * width
        
    end
    
    defp sortBounds(lb, ub) do
        
        lowerBound = parseTerm(lb)
        upperBound = parseTerm(ub)
        
        if lowerBound < upperBound do
            [lowerBound, upperBound]
        else
            [upperBound, lowerBound]
        end
        
    end
    
    def riemanns do
        lb1 = IO.gets "Enter in the Lower Bound: "
        lb2 = String.slice(lb1, 0, String.length(lb1) - 1)

        #lowerBound = parseTerm(lb2)
        #IO.puts lowerBound
        
        ub1 = IO.gets "Enter in the Upper Bound: "
        ub2 = String.slice(ub1, 0, String.length(ub1) - 1)

        #upperBound = parseTerm(ub2)
        #IO.puts upperBound        
        
        [lowerBound | ub3] = sortBounds(lb2, ub2)
        [upperBound | _ ] = ub3 
                
        hopVal = (upperBound - lowerBound) / @divider
        #IO.puts hop
        
        #calcRange = makeRange(lowerBound, upperBound, hopVal, [])
        calcRange = Enum.map(1..@divider, fn(x) -> x * hopVal + lowerBound end)

        
        allTerms = takeTerms([])
        
        numTerms = Enum.count(allTerms) 
        
        allRects = Enum.map(calcRange, fn(xVal) -> makeRect(xVal, hopVal, allTerms) end)
        total = Float.round(Enum.sum(allRects), 3)
                
        IO.write "The area underneath the curve " 
        
        for c <- 0..numTerms - 1 do
            [co | exponent] = Enum.at(allTerms, c)
            [ex | _] = exponent
            
            cond do
                c != 0 and co < 0 -> 
                    IO.write "- "
                c != 0 and co >= 0 -> 
                    IO.write "+ "
                true -> nil
            end
            
            if c == 0 do
                IO.write "#{co}x^#{ex} "
            else
                IO.write "#{abs(co)}x^#{ex} "
            end
            
            #IO.write c
        end
        
        IO.puts "from #{lowerBound} to #{upperBound} is about #{total}"
                
        #for xVal <- calcRange do
           #IO.puts xVal
         #  spawn fn -> 
          #      send(self(), {:rect, makeRect(xVal, hopVal, allTerms)})
           #end
            
        #end   
        
        #receive do
         #   {:rect, rectVal} -> IO.puts rectVal
          #  true -> IO.puts "Fail"
        #end   
        
    end

end

Calculus.riemanns






