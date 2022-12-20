pragma solidity 0.8.7;

contract Monopoly 
{
    // Variables générales
    uint nbr_parties;
    uint nbr_parties_joues;
    uint index;
    uint nbr_joueur;
    address founder;
    uint[] index_parties_jouables;

    struct Partie {
        //règle de la partie
        uint nbr_max_joueur;
        uint nbr_joueurs_present;
        bool encours;
        address[] joueurs_address;
    }
    struct Personne 
    {
        uint solde;
        string nom;
        bool en_game;
        uint index_partie_jouer;
    }
    mapping(uint => Partie) Monopoly_partie;
    mapping(address => Personne) Joueurs;
    constructor()
    {
                    founder = msg.sender;
                    index = 0;

    }
    modifier isOwner() {
        require(msg.sender ==founder);
        _;
    }

    function creer_partie() public isOwner 
    {
        Monopoly_partie[index].nbr_max_joueur = 4;
        Monopoly_partie[index].nbr_joueurs_present = 0;
        Monopoly_partie[index].encours = false;
        index_parties_jouables.push(index);
        index++;
    }
    function retourner_partie_valide() public view  returns(uint[] memory)
    {
        
        return (index_parties_jouables);
    }

    function modifier_partie(uint indexdelapartie) private 
    {
        Monopoly_partie[index].encours = true;

        delete index_parties_jouables[indexdelapartie];

    }
    function creer_joueurs(string memory name) public 
    { 
        require(bytes(name).length!=0, "Nom vide");
        require(bytes(Joueurs[msg.sender].nom).length ==0, "vous avez deja un nom"); 
        Joueurs[msg.sender].nom = name;
        Joueurs[msg.sender].solde = 200;
    } 
    function retourner_nom_joueur() public view returns(string memory)
    {
        return Joueurs[msg.sender].nom;
    }
    function retourner_enjeu_joueur() public view returns(bool)
    {
        return Joueurs[msg.sender].en_game;
    }
    function retourner_index_joueur() public view returns(uint)
    {
        return Joueurs[msg.sender].index_partie_jouer;
    }
    function rejoindre_partie(uint _index) public 
    {
        require(bytes(Joueurs[msg.sender].nom).length !=0, "Veuillez creer un joueur"); 

        require(Monopoly_partie[_index].encours ==false);
        require(Joueurs[msg.sender].en_game == false, "vous etes deja en partie");
        Joueurs[msg.sender].en_game = true;
        if (Monopoly_partie[_index].nbr_joueurs_present< Monopoly_partie[_index].nbr_max_joueur) 
        {
            Monopoly_partie[_index].nbr_joueurs_present++;
            Monopoly_partie[_index].joueurs_address.push(msg.sender);
            
            Joueurs[msg.sender].index_partie_jouer = _index;

            
        }
        
        if (Monopoly_partie[_index].nbr_joueurs_present== Monopoly_partie[_index].nbr_max_joueur) 
        {
            modifier_partie(_index);
        }

    }
    function retourner_address_joueurs_partie(uint _index) public view returns (address[] memory)
    {
        return Monopoly_partie[_index].joueurs_address;
    }
    function retourner_nbr_joueur_partie(uint _index) public view isOwner returns (uint)
    {
        return Monopoly_partie[_index].nbr_joueurs_present;
    }
    

    
}