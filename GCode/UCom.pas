{   Copyright 2008 Jerome

    This file is part of StartCom.

    StartCom is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    StartCom is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with CncNet98.  If not, see <http://www.gnu.org/licenses/>.

    The software Jedicut is allowed to statically and dynamically link this library.
}

unit UCom;

interface

uses
  SysUtils, UType;

  // Fonction renvoyant le code famille de la dll, ce code indique le type de la dll
  // Les codes possibles : voir UType.pas, fichier commun aux dll
  function GetDllFamily : byte; export

  // M�thode de la dll permettant de d�finir si la dll propose une IHM d'initialisation
  // GetDllToInit est obligatoirement renseign� si ShowDllForm est renseign�e pour une dll de communication
  // function GetDllToInit : integer;

  // M�thode passant le Handle de l'application
  // procedure ShowDllForm(appHandle : HWND);

  procedure GetDescription(Cible : PChar; tailleCible: integer);
  function EmettreBit(bitRotation, bitSens : byte ; vitesse : integer; chauffe : double) : smallInt ; export;
  procedure MoteurOnOff(moteurOn : boolean); export;
  procedure InitialiserChauffeEtCommunication(portBase : word ;
                                              ParamChauffe : TParametreChauffe ;
                                              ParamCommunication : TParametreCommunication ;
                                              Materiau : TMateriau); export;
  function EtatMachine : byte; export;
  function LireChauffeMachine : double; export;

  procedure AdapterOrdres(var ArrayOrdres : TArrayOrdresMoteur); export;

  // Vu que dans dll USB
  //procedure LibererRessources; export;
  //function GetChauffeMachine : double; export;

implementation

const TIME_OUT = 10000;

var
  ParametreChauffe : TParametreChauffe;
  ParametreCommunication : TParametreCommunication;
  MateriauActif : TMateriau;
  periodeChauffe : integer;
  pulseChauffe : integer;
  bSignalChauffeHaut : boolean; // Variable permettant de ne positionner le signal de chauffe qu'une seule fois par p�riodede chauffe
  horloge, ancienneHorloge : byte; // Variable pour d�tecter le signal d'horloge
  portAdresseBase : word; // Adresse de base du port parall�le

{-----------------------------------------------------------------}
{ Renvoie le type de la dll }
function GetDllFamily : byte;
begin
  Result := DLL_FAMILY_COM_SEGMENT;
end;

{-----------------------------------------------------------------}
{ Renvoie la description de la dll }
procedure GetDescription(Cible : PChar; tailleCible: integer);
var
  Description : ShortString;
begin
  Description := 'GCode generator. Version 0.0';
  StrPLCopy(Cible, Description, tailleCible);
end;

{-----------------------------------------------------------------}
{ M�thode de la dll g�rant l'alimentation des moteurs }
procedure MoteurOnOff(moteurOn : boolean);
begin
  // M�thode non utilis� dans cette dll
  Sleep(1);
  // G�rer l'alimentation des moteurs
  if moteurOn then
  begin
    // Alimenter les moteurs
  end else begin
    // Emettre la remise � zero des bits moteurs
    // Couper l'alimentation des moteurs et mettre la chauffe � 0
  end;
end;

{-----------------------------------------------------------------}
{ M�thode de la dll d'envoi des bits propre � un type de machine }
function EmettreBit(bitRotation, bitSens : byte ; vitesse : integer; chauffe : double) : smallInt;
var
  codeRetour : smallInt;
begin
  // M�thode non utilis�e dans cette dll
  codeRetour := NO_ERROR;
  Result := codeRetour;
end;

{-----------------------------------------------------------------}
{ Initialiser les param�tre de la chauffe chauffe }
procedure InitialiserChauffeEtCommunication(portBase : word ; ParamChauffe : TParametreChauffe ; ParamCommunication : TParametreCommunication ; Materiau : TMateriau);
begin
  portAdresseBase := portBase;
  ParametreChauffe := ParamChauffe;
  ParametreCommunication := ParamCommunication;
  MateriauActif := Materiau;
  // En fait ce n'est pas la p�riode mais le temps ou le signal est � 1
  periodeChauffe := Trunc(Int(MateriauActif.pourcentage1));
  // Compteur d'impulsion de chauffe
  pulseChauffe := 0;

end;

{-----------------------------------------------------------------}
{ Lire des �tats de la machine                }
{ - Pour l'instant lecture du mode de chauffe 1 mode manuel, 0 mode PC }
function EtatMachine : byte;
var
  retour : byte;
begin
  // Non utilis�
  retour := 1;
  Result := retour;
end;

{-----------------------------------------------------------------}
{ Adapter les coordonn�es en fonction de la machine }
procedure AdapterOrdres(var ArrayOrdres : TArrayOrdresMoteur);
begin

end;

{-----------------------------------------------------------------}
{ Fonction retournant la valeure de la chauffe }
function LireChauffeMachine : double;
var
  retour : double;
begin
  Randomize; // Initialise le random utilis� pour fournir une valeur de chauffe de test
  // Result := -1; // Le signal de chauffe n'arrive pas � �tre interpr�t�, soit il est absent, soit Jedicut n'arrive pas � le lire
  retour := Random;
  Result := retour; // Valeur entre 0 et 1, 0 �tant la chauffe maxi
end;

end.
