{   Copyright 2008 Jerome

    This file is part of MaxCom_XP.

    MaxCom_XP is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    MaxCom_XP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MaxCom_XP.  If not, see <http://www.gnu.org/licenses/>.

    The software Jedicut is allowed to statically and dynamically link this library.
}

unit UCom;

interface

uses
  SysUtils, UType;

  function GetDllFamily : byte; export
  procedure GetDescription(Cible : PChar; tailleCible: integer);
  function EmettreBit(bitRotation, bitSens : byte ; vitesse : integer ; chauffe : double) : smallInt; export;
  procedure MoteurOnOff(moteurOn : boolean) ; export;
  procedure InitialiserChauffeEtCommunication(portBase : word ;
                                              ParamChauffe : TParametreChauffe ;
                                              ParamCommunication : TParametreCommunication ;
                                              Materiau : TMateriau); export;
  function EtatMachine : byte; export;

  // Fonctions priv�es

  procedure PortOut(Port : Word; Data : Byte); stdcall; external 'io.dll';
  function PortIn(Port : Word) : Byte; stdcall; external 'io.dll';

implementation

var
  portAdresseBase : word; // Adresse de base du port parall�le

{-----------------------------------------------------------------}
{ Renvoie le type de la dll }
function GetDllFamily : byte;
begin
  Result := 0;
end;

{-----------------------------------------------------------------}
{ Renvoie la description de la dll }
procedure GetDescription(Cible : PChar; tailleCible: integer);
var
  Description : ShortString;
begin
  Description := 'Protocole utilis� avec la machine prototype, compatible Windows XP. Version 0.6.1';
  StrPLCopy(Cible, Description, tailleCible);
end;

{-----------------------------------------------------------------}
{ M�thode de la dll g�rant l'alimentation des moteurs }
procedure MoteurOnOff(moteurOn : boolean);
begin
  // G�rer l'alimentation des moteurs
  if moteurOn then
  begin
    // Alimenter les moteurs
    PortOut(portAdresseBase + 2, 0);
  end else
  begin
    // Emettre la remise � zero des bits moteurs
    PortOut(portAdresseBase, 0);
    // Couper l'alimentation des moteurs et mettre la chauffe � 0
    PortOut(portAdresseBase + 2, 8);
  end;
end;

{-----------------------------------------------------------------}
{ M�thode de la dll d'envoi des bits propre � un type de machine }
function EmettreBit(bitRotation, bitSens : byte ; vitesse : integer ; chauffe : double) : smallInt;
var
  dat : byte;
  i : integer;
begin
  // Calcul
  dat := bitRotation + bitSens;

  // Envoi du bit
  PortOut(portAdresseBase, dat);

  // Temporisation
  if (vitesse >= 0) then
  begin
    for i := 0 to vitesse do
    begin
    end;
  end
  else
  begin
    Sleep(-1 * vitesse);
  end;

  // Envoi de 0 (horloge)
  PortOut(portAdresseBase, 0);

  Result := NO_ERROR;
end;

{-----------------------------------------------------------------}
{ Initialiser les param�tre de la chauffe chauffe }
procedure InitialiserChauffeEtCommunication(portBase : word ; ParamChauffe : TParametreChauffe ; ParamCommunication : TParametreCommunication ; Materiau : TMateriau);
begin
  portAdresseBase := portBase;
  //portAdresseBase := $FCE0;
  // Chauffe non support�e par cette machine
end;

{-----------------------------------------------------------------}
{ Lire des �tats de la machine                }
{ - Pour l'instant lecture du mode de chauffe 1 mode manuel, 0 mode PC }
function EtatMachine : byte;
begin
  Result := 1;
end;

end.
