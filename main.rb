
class Graph
  attr_accessor :vertices_list, :graph_no   
  @@cnt_graph=0
  
  def initialize(cnt_vertex)
    @@cnt_graph+=1
    @graph_no =@@cnt_graph
    @vertices_list = [] 
    @cnt_vertex = cnt_vertex
    create_vertex_list()
  end
   
  def create_vertex_list()
    for i in 0..@cnt_vertex-1
      #puts "Vytvarim novy uzel c.#{i+1} na pozici #{i}"
      @vertices_list[i]=Vertex.new(i+1)
      #puts "overeni #{(@vertices_list[i]).vertex_no}"
    end
  end
  
  def get_vertex(number) # vrátí uzel, který je na pozici "number"
    ver = @vertices_list
    (number-1).times { ver = ver.next }
    return ver
  end
  
  def set_neighbors(string)
    string.chomp #zbaví string entru na konci (\n nebo \n\r)
    # I want x="[5,3,46,6,5]" (the arrray, not the string)
    # 1. x[1..-2] is the string without the brackets.
    # 2. split(',') splits the string at commas into an array of strings.
    # 3. collect! calls .to_i on each string in the array and replaces the string with the result of the conversion.
    array = string[0..-1].split(' ').collect! {|n| n.to_i}
    cnt = array[1] #kolik jich bude
    ver = (@vertices_list[array[0]-1]) #najdeme uzel, do kterého chceme přidat sousedy ("array[0]-1" protože @verticle_list je od 0)
    ver.cnt_neighbors=array[1] # zapíšu počet sousedů

    for i in 0..cnt-1      
      ver.set_neighbor(@vertices_list[array[i+2]-1], i)  #naplníme pole sousedů
      #puts "pro uzel c.#{ver.vertex_no} pridavam souseda c.#{@vertices_list[array[i+2]-1].vertex_no} na pozici #{i}"
    end
  end
  
  def search_bfs(vertex)
    index=0
    last_index = index
    queue=[]
    result = ""
 #   puts "probiha BFS s pocatecnim uzlem c.#{vertex}"
    
    clear_vertex_states() #musím vymazat příznaky 
    ver = @vertices_list[vertex-1]
    queue[index]= ver #počáteční uzel ve frontě
    ver.state = "O" #již se s ním pracovalo (je ve frontě)
    while queue[index]
      ver = queue[index]
      ver.cnt_neighbors

      for j in 0..(ver.cnt_neighbors-1)
        if ver.neighbor_list[j].state == "F"
          last_index += 1
          # puts "pridavam do fronty uzel c.#{ver.neighbor_list[j].vertex_no} na pozici #{last_index}"
          ver2 = ver.neighbor_list[j]
          queue[last_index]= ver2
          ver2.state = "O"
        else
          #    puts "uzel c.#{ver.neighbor_list[j].vertex_no} je #{ver.neighbor_list[j].state}"
        end 
      end
      
      result +="#{ver.vertex_no} "
      ver.state = "C"
      # puts "Uzaviram uzel c.#{ver.vertex_no}"
      index+=1
    end
    
    return result
  end
  
  def search_dfs(vertex)
    result=""
    stack = []
  #  puts "probiha DFS s pocatecnim uzlem c.#{vertex}"
    
    clear_vertex_states() #musím vymazat příznaky   
    ver = @vertices_list[vertex-1] #načtem počáteční uzel
    ver.state = "O"
    result += "#{ver.vertex_no} "
    stack.push(ver)
    
    while (obj = stack.pop) != nil
      #puts "vytahuji uzel c.#{obj.vertex_no}"
      if (obj2 = obj.return_first_fresh_neighbor())!=nil
       # puts "vracim uzel c.#{obj.vertex_no} na stack"
        stack.push(obj)
        obj2.state = "O"
        result += "#{obj2.vertex_no} "
       # puts "pridavam uzel c.#{obj.vertex_no} na stack"
        stack.push(obj2)
      else
        obj.state = "C"
      end
    end
    
    return result
  end
    
  def clear_vertex_states()
    for i in 0..@cnt_vertex-1
      @vertices_list[i].state = "F"
    end
  end
  
  
end

class Vertex
  attr_accessor :neighbor_list, :vertex_no, :cnt_neighbors, :state
 
  def initialize(vertex_no)
    @vertex_no = vertex_no
    @cnt_neighbors = 0
    @neighbor_list = []
    @state = "F" #F=fresh, O=open, C=close 
  end
  
  def set_neighbor(neighbor, index)
    @neighbor_list[index]=neighbor
    #  puts "@neighbor_list[#{index}]=#{neighbor.vertex_no}"
  end
  
  def return_first_fresh_neighbor()
    result = nil
    for i in 0..@cnt_neighbors-1
      ver = @neighbor_list[i]
      if ver.state == "F"
        return ver
      end
    end
    return result
  end
  
end


cnt_graphs = gets.to_i
#puts "Pocet grafu = #{cnt_graphs}"

while cnt_vertex = gets #gets načítá celé řádky, když nejsou vrací "nil" a "nil" je zde jako "false"
 # puts "Pocet uzlu = #{cnt_vertex}"
  cnt_vertex = cnt_vertex.to_i

  g = Graph.new(cnt_vertex)
 # puts "--------------------"
  puts "graph #{g.graph_no}"
 # puts "--------------------"
  
  cnt_vertex.times { #načtu sousední uzly ke každdému uzlu
    # puts line = gets
    g.set_neighbors(gets)
  }
  
 
 # puts "Provest tyto akce:"
  while (line = gets) != "0 0\n"
    #puts line
    array = line[0..-1].split(' ').collect! {|n| n.to_i}
    
    if array[1]==1
      puts "#{g.search_bfs(array[0])}" 
    else
      puts "#{g.search_dfs(array[0])}"
    end  
  end

  #puts "Konec grafu"

end
