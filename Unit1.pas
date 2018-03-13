unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI, Vcl.StdCtrls, Vcl.FileCtrl;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    amcAmazon: TAmazonConnectionInfo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    S3 : TAmazonStorageService;
    S3Region : TAmazonRegion;
    sRegion : String;
  end;

const
  AccessKey = '';
  SecretKey = '';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ResponseInfo : TCloudResponseInfo;
  strTemp : TStrings;
  I: Integer;
begin
  ResponseInfo := TCloudResponseInfo.Create;
  try
    ListBox1.Items.Clear;
    strTemp := S3.ListBuckets(ResponseInfo);

    if Assigned(strTemp) then
      for I := 0 to Pred(strTemp.Count) do
        ListBox1.Items.Add(strTemp.Names[I]);
  finally
    ResponseInfo.Free;
    strTemp.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  strBucket : String;
  bucketInfo : TAmazonBucketResult;
  objectInfo : TAmazonObjectResult;
begin
  strBucket := ListBox1.Items[ListBox1.ItemIndex];
  bucketInfo := S3.GetBucket(strBucket, nil);

  ListBox2.Items.Clear;
  for objectInfo in bucketInfo.Objects do
  begin
    ListBox2.items.Add(objectInfo.Name);

    //listItem.Caption := objectInfo.Name;
    //listItem.SubItems.Add(IntToStr(objectInfo.Size));
    //listItem.SubItems.Add(objectInfo.LastModified);
    //listItem.SubItems.Add(objectInfo.StorageClass);
    //listItem.SubItems.Add(objectInfo.OwnerDisplayName);
    //listItem.SubItems.Add(objectInfo.ETag);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  sNmArquivo  : String;
  FileContent : TBytes;
  fReader     : TBinaryReader;
  Meta        : TStringList;
begin
  //Seleciona o arquivo para upload
  if OpenDialog1.Execute then
  begin
    //Captura o nome do arquivo selecionado no diálogo
    sNmArquivo := ExtractFileName(OpenDialog1.FileName);

    //Cria o stream do arquivo para upload
    fReader := TBinaryReader.Create(OpenDialog1.FileName);
    try
      FileContent := fReader.ReadBytes(fReader.BaseStream.Size);
    finally
      fReader.Free;
    end;

    try
      //Prepara o upload
      try
        Meta := TStringList.Create;
        Meta.Add('Content-type=text/xml');
        Screen.Cursor := crHourGlass;
        //Faz o upload
        try
          S3.UploadObject(ListBox1.Items[ListBox1.ItemIndex], sNmArquivo, FileContent, False, meta);
          MessageDlg('Operação efetuada com sucesso!', mtInformation, [mbOk], 0);
        except
          on E:Exception do
            ShowMessage(E.message);
        end;
      finally
        Meta.Free;
        Screen.Cursor := crDefault;
      end;
    except on E:Exception do
      begin
        Screen.Cursor := crDefault;
        MessageDlg('Ocorreu um erro ao tentar fazer o upload do arquivo.', mtError, [mbOk], 0);
      end;
    end;
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  FStream : TStream;
  sDir    : String;
  sFile   : String;
begin
  FStream := TMemoryStream.Create;
  try
    sFile := ListBox2.Items[ListBox2.ItemIndex];
    //Download do arquivo para a variávei FStream
    S3.GetObject(ListBox1.Items[ListBox1.ItemIndex], sFile, FStream);
    FStream.Position := 0;

    //Define o diretório padrão para donwload
    sDir       := ExtractFilePath(ParamStr(0));
    //Permite selecionar a pasta
    if SelectDirectory('Selecione a pasta', 'C:\', sDir) then
    begin
      //Salva o arquivo na pasta selecionada
      TMemoryStream(FStream).SaveToFile(sDir + PathDelim + sFile);
      MessageDlg('Arquivo salvo na pasta selecionada: ' + #13#10 +
                 sDir + PathDelim + sFile, mtInformation, [mbOk], 0);
    end;
  finally
    FStream.Free;
    Screen.Cursor := crDefault;
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  sFile : String;
begin
  sFile := ListBox2.Items[ListBox2.ItemIndex];
  if MessageDlg('Deseja excluir o arquivo do servidor?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      //Exclui efetivamente o arquivo
      try
        Screen.Cursor := crHourGlass;
        S3.DeleteObject(ListBox1.Items[ListBox1.ItemIndex], sFile);
      finally
        Screen.Cursor := crDefault;
      end;
    except
      MessageDlg('Ocorreu um erro ao tentar a exclusão', mtError, [mbOk], 0);
    end;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  S3.CreateBucket(Edit1.Text, TAmazonACLType.amzbaPrivate, TAmazonRegion.amzrEUWest1, nil);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  S3.DeleteBucket(ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  amcAmazon.AccountName := AccessKey;
  amcAmazon.AccountKey := SecretKey;

  S3 := TAmazonStorageService.Create(amcAmazon);
  sRegion := TAmazonStorageService.GetRegionString(S3Region);

  Label1.Caption := amcAmazon.StorageEndpoint;
  Label2.Caption := sRegion;
end;

end.
