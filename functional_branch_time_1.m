%   ********************  FUNCTIONAL_BRANCH_TIME_1 *************************
% Author: Carlos Rogéliz, 2025 
%         carlos.rogeliz@gmail.com
%
% Función que calcula: Tiempos medios de flujo
% una red fluvial topológica. 
% 
% FUNCTION OUTPUTS:
% -------------------
%   cumulative_Flow_Time                  : vector con el valor acumulado de tiempo medio de flujo desde una barrera hacia
%                                           aguas arriba 
% 
% FUNCTION INPUTS:
% -------------------
%
%  start_id_downstream             : Identificador de tramo fluvial
%                                    localizado mas aguas abajo de la red
%                                    fluvial (e.i. ID del tramo fluvial que
%                                    correpsonde a la desembocadura del
%                                    rio).
%  arc_ids                         : Vector que contiene los ID de todos
%                                    los tramos fluviales
%  arc_start_nodes y arc_end_nodes : Vectores que contienen la topología de
%                                    la red fluvial. Respectivamente
%                                    permiten identificar los nodos inicial
%                                    y final de cada tramo fluvial
%  functional_network_arcs         : vector que asigna a cada 
%                                    tramo de la red fluvial
%                                    el ID del obstáculo localizado aguas abajo (e.g.
%                                    un embalse). Todos los tramos
%                                    que tengan el mismo valor de
%                                    "functional_network_arcs"
%                                    pertenecen a una misma red
%                                    fluvial conectada. Por defecto,
%                                    la red de la desembocadura,
%                                    se identifica con el functional_network_arcs
%                                    = 0
%   Flow_Time                      : vector que contiene los tiempos de flujo
%                                    para cada uno de los tramos que hacen
%                                    parte de la red fluvial
%                                    configura la red fluji


function [cumulative_Flow_Time] = functional_branch_time_1(start_id_downstream, arc_ids, arc_start_nodes, arc_end_nodes,functional_network_arcs,...
                                                            Flow_Time)
                                                            
    %Identifica para cada Arco el Arco aguas abajo con el cual tiene
    %conexion
    downstream_arcs_index=zeros(length(arc_ids),1);
    for a=1:length(arc_ids)
        check=isempty(find(arc_end_nodes(a) == arc_start_nodes,1));
        if check==1
            downstream_arcs_index(a)=0;
        else
            downstream_arcs_index(a)=find(arc_end_nodes(a) == arc_start_nodes);
        end
    end
        
    %Recorre la red desde aguas abajo hacia aguas arriba acumulando el
    %tiempo
        
    cumulative_Flow_Time=Flow_Time;
    current_Arc_id=find(arc_ids==start_id_downstream); %Arco Aguas Abajo 
        
    vector_ctr=zeros(length(arc_ids),1); %Vector de control para acumulación
    check_exit=0;
        
    while check_exit==0
        cont1=1;
        next_Arc_id=0;
        for j=1:length(current_Arc_id)
            next_Arcs=find(arc_end_nodes == arc_start_nodes(current_Arc_id(j)));
            for z=1:length(next_Arcs)
                next_Arc_id(cont1,1)=next_Arcs(z);
                cont1=cont1+1;
            end
        end
            
        for w=1:length(next_Arc_id)
            Arc_id_to_add=downstream_arcs_index(next_Arc_id(w));
            
            if vector_ctr(next_Arc_id(w))==0
                if functional_network_arcs(next_Arc_id(w))==functional_network_arcs(Arc_id_to_add)
                    cumulative_Flow_Time(next_Arc_id(w))=cumulative_Flow_Time(next_Arc_id(w))+cumulative_Flow_Time(Arc_id_to_add);
                else
                    cumulative_Flow_Time(next_Arc_id(w))=Flow_Time(next_Arc_id(w));
                end
                vector_ctr(next_Arc_id(w))=1;
            end
        end
        current_Arc_id=next_Arc_id;
        
        %salida de bucle While
        check_2=0; %check para continuar buscando o no nuevos branches
        for c=1:length(current_Arc_id)
            if check_2==0
                continuity_check=find(arc_start_nodes(current_Arc_id(c)) == arc_end_nodes,1);
                if isempty(continuity_check)==0
                    check_2=1;
                    %c=length(current_Arc_id)+1; %sale de comprobacion - sino continua buscando
                end
            end
        end
        if isempty(continuity_check)==1
            check_exit=1;
        end
    end
end