{*******************************************************}
{                                                       }
{             DxAutoInstaller IDE Classes               }
{                                                       }
{        http://www.delphier.com/DxAutoIntaller         }
{        Copyright(c) 2014 by faceker@gmail.com         }
{                                                       }
{*******************************************************}

unit DxIDE;

interface

uses
  SysUtils, JclIDEUtils;

type
  TDxIDEPlatform = TJclBDSPlatform;
  TDxIDE = TJclBorRADToolInstallation;
  TDxBDSIDE = TJclBDSInstallation;
  TDxIDEArray = array of TDxIDE;

  TDxIDEs = class(TJclBorRADToolInstallations)
  public
    function IndexOf(IDE: TDxIDE): Integer;
  end;

  function IsSupportWin64(IDE: TDxIDE): Boolean;
  function IsRADStudio(IDE: TDxIDE): Boolean;
  function GetIDEOverrideEnvironmentVariable(IDE: TDxIDE; const Name: String): String;
  procedure SetIDEOverrideEnvironmentVariable(IDE: TDxIDE; const Name, Value: String);

const
  Win32 = bpWin32;
  Win64 = bpWin64;
  DxIDEPlatformNames: array[TDxIDEPlatform] of String = (BDSPlatformWin32, BDSPlatformWin64, BDSPlatformOSX32);
  BPLExtName = '.bpl';
  IDEEnvironmentVariablesSectionName = 'Environment Variables';

implementation

{ TDxIDEs }

function TDxIDEs.IndexOf(IDE: TDxIDE): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if IDE = Installations[I] then begin
      Result := I;
      Break;
    end;
end;


function IsSupportWin64(IDE: TDxIDE): Boolean;
begin
  Result := clDcc64 in IDE.CommandLineTools;
end;

function IsRADStudio(IDE: TDxIDE): Boolean;
begin
  Result := IDE.RadToolKind = brBorlandDevStudio;
end;

function GetIDEOverrideEnvironmentVariable(IDE: TDxIDE; const Name: String): String;
begin
  Result := IDE.ConfigData.ReadString(IDEEnvironmentVariablesSectionName, Name, EmptyStr);
end;

procedure SetIDEOverrideEnvironmentVariable(IDE: TDxIDE; const Name, Value: String);
begin
  if Value <> EmptyStr then
    IDE.ConfigData.WriteString(IDEEnvironmentVariablesSectionName, Name, Value)
  else
    IDE.ConfigData.DeleteKey(IDEEnvironmentVariablesSectionName, Name);
end;


end.
