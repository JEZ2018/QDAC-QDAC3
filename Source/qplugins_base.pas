unit qplugins_base;

interface

uses classes, types, sysutils;

const
  SQPluginsVersion = '3.1'; // 3.1��
  // ��־��¼����
  LOG_EMERGENCY: BYTE = 0;
  LOG_ALERT = 1;
  LOG_FATAL = 2;
  LOG_ERROR = 3;
  LOG_WARN = 4;
  LOG_HINT = 5;
  LOG_MESSAGE = 6;
  LOG_DEBUG = 7;
  // Ԥ����֪ͨ��ID
  NID_MANAGER_REPLACED = 0; // ������������滻�����ֻ֪ͨ��Ҫ�����ڲ����Ӧ��
  NID_MANAGER_FREE = 1; // �����������Ҫ�������ͷ�
  NID_LOADERS_STARTING = 2; // ��������������
  NID_LOADERS_STARTED = 3; // �������������
  NID_LOADERS_STOPPING = 4; // ������ֹͣ��
  NID_LOADERS_STOPPED = 5; // ��������ֹͣ
  NID_LOADERS_PROGRESS = 6; // ����������/ֹͣ����
  NID_LOADER_ERROR = 7; // ���������س���
  NID_PLUGIN_LOADING = 8; // ���ڼ��ز��
  NID_PLUGIN_LOADED = 9; // ���ز�����
  NID_PLUGIN_UNLOADING = 10; // ����׼��ж��
  NID_PLUGIN_UNLOADED = 11; // ����ж�����
  NID_NOTIFY_PROCESSING = 12; // ֪ͨ��Ҫ������
  NID_NOTIFY_PROCESSED = 13; // ֪ͨ�Ѿ��������
  NID_SERVICE_READY = 14; // ����ע�����

type
  TQAsynProcG = procedure(AParams: IInterface); stdcall;

  // �������Ͷ���
  // ��
  IQStream = interface
    ['{BCFD2F69-CCB8-4E0B-9FE9-A7D58797D1B8}']
    function Read(pv: Pointer; cb: Cardinal): Cardinal; stdcall;
    function Write(pv: Pointer; cb: Cardinal): Cardinal; stdcall;
    function Seek(AOffset: Int64; AFrom: BYTE): Int64; stdcall;
    procedure SetSize(ANewSize: UInt64); stdcall;
    function CopyFrom(AStream: IQStream; ACount: Int64): Int64; stdcall;
  end;

  // ������񻯣�����ʹ�ò�ͬ����֮�佻��
  TQParamType = (ptUnknown,
    // Integer Types
    ptInt8, ptUInt8, ptInt16, ptUInt16, ptInt32, ptUInt32, ptInt64, ptUInt64,
    ptFloat4, ptFloat8, // Float types
    ptDateTime, ptInterval, // DateTime types
    ptAnsiString, ptUtf8String, ptUnicodeString, // String types
    ptBoolean, // Boolean
    ptGuid, // Guid
    ptBytes, // Binary
    ptStream, // ��
    ptArray, // Array
    ptInterface);
  IQParams = interface;

  IQString = interface
    ['{B2FB1524-A06D-47F6-AA85-87C2251F2FCF}']
    procedure SetValue(const S: PWideChar); stdcall;
    function GetValue: PWideChar; stdcall;
    function GetLength: Integer; stdcall;
    procedure SetLength(ALen: Integer); stdcall;
    property Value: PWideChar read GetValue write SetValue;
    property Length: Integer read GetLength write SetLength;
  end;

  // ��������
  IQParam = interface
    ['{8641FD44-1BC3-4F04-B730-B5406CDA17E3}']
    function GetName: PWideChar; stdcall;
    function GetAsInteger: Integer; stdcall;
    procedure SetAsInteger(const AValue: Integer); stdcall;
    function GetAsInt64: Int64; stdcall;
    procedure SetAsInt64(const AValue: Int64); stdcall;
    function GetAsBoolean: Boolean; stdcall;
    procedure SetAsBoolean(const AValue: Boolean); stdcall;
    function GetAsSingle: Single; stdcall;
    procedure SetAsSingle(const AValue: Single); stdcall;
    function GetAsFloat: Double; stdcall;
    procedure SetAsFloat(const AValue: Double); stdcall;
    function GetAsString: IQString; stdcall;
    procedure SetAsString(const AValue: IQString); stdcall;
    function GetAsGuid: TGuid; stdcall;
    procedure SetAsGuid(const Value: TGuid); stdcall;
    function GetAsBytes(ABuf: PByte; ABufLen: Cardinal): Cardinal; stdcall;
    procedure SetAsBytes(ABuf: PByte; ABufLen: Cardinal); stdcall;
    function GetIsNull: Boolean; stdcall;
    procedure SetNull; stdcall;
    function GetAsArray: IQParams; stdcall;
    function GetAsStream: IQStream; stdcall;
    procedure SetAsStream(AStream: IQStream); stdcall;
    function GetParent: IQParams; stdcall;
    function GetType: TQParamType; stdcall;
    procedure SetType(const AType: TQParamType); stdcall;
    function GetAsInterface: IInterface; stdcall;
    procedure SetAsInterface(const AIntf: IInterface); stdcall;
    function GetIndex: Integer; stdcall;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsGuid: TGuid read GetAsGuid write SetAsGuid;
    property IsNull: Boolean read GetIsNull;
    property Name: PWideChar read GetName;
    property AsArray: IQParams read GetAsArray;
    property AsStream: IQStream read GetAsStream write SetAsStream;
    property AsString: IQString read GetAsString write SetAsString;
    property Parent: IQParams read GetParent;
    property ParamType: TQParamType read GetType;
    property AsInterface: IInterface read GetAsInterface write SetAsInterface;
    property Index: Integer read GetIndex;
  end;

  // �����б�
  IQParams = interface
    ['{B5746B65-7586-4DED-AE20-D4FF9B6ECD9E}']
    function GetItems(AIndex: Integer): IQParam; stdcall;
    function GetCount: Integer; stdcall;
    function ByName(const AName: PWideChar): IQParam; stdcall;
    function ByPath(APath: PWideChar): IQParam; stdcall;
    function Add(const AName: PWideChar; AParamType: TQParamType): IQParam;
      overload; stdcall;
    function Add(const AName: PWideChar; AChildren: IQParams): IQParam;
      overload; stdcall;
    function GetAsString: IQString; stdcall;
    procedure Delete(AIndex: Integer); stdcall;
    procedure Clear; stdcall;
    function IndexOf(const AParam: IQParam): Integer; stdcall;
    procedure SaveToStream(AStream: IQStream); stdcall;
    procedure LoadFromStream(AStream: IQStream); stdcall;
    procedure SaveToFile(const AFileName: PWideChar); stdcall;
    procedure LoadFromFile(const AFileName: PWideChar); stdcall;
    property Items[AIndex: Integer]: IQParam read GetItems; default;
    property Count: Integer read GetCount;
    property AsString: IQString read GetAsString;
  end;

  // �汾��Ϣ
  TQShortVersion = packed record
    case Integer of
      0:
        (Major, Minor, Release, Build: BYTE); // �������������������İ汾��
      1:
        (Value: Integer);
  end;
{$IF RTLVersion>=21}
{$M+}
{$IFEND}

  // �汾��Ϣ�ṹ
  TQVersion = packed record
    Version: TQShortVersion; // �汾
    Company: array [0 .. 63] of WideChar; // ��˾��
    Name: array [0 .. 63] of WideChar; // ģ������
    Description: array [0 .. 255] of WideChar; // ����
    FileName: array [0 .. 259] of WideChar; // ԭʼ�ļ���
  end;

  // ����汾��Ϣ
  IQVersion = interface
    ['{4AD82500-4148-45D1-B0F8-F6B6FB8B7F1C}']
    function GetVersion(var AVerInfo: TQVersion): Boolean; stdcall;
  end;

  IQServices = interface;
  IQLoader = interface;

  // ��������
  IQService = interface
    ['{0DA5CBAC-6AB0-49FA-B845-FDF493D9E639}']
    function GetInstance: IQService; stdcall;
    function GetOwnerInstance: THandle; stdcall;
    function Execute(AParams: IQParams; AResult: IQParams): Boolean; stdcall;
    function Suspended(AParams: IQParams): Boolean; stdcall;
    function Resume(AParams: IQParams): Boolean; stdcall;
    function GetParent: IQServices; stdcall;
    function GetInstanceCreator: IQService; stdcall;
    procedure AddExtension(AInterface: IInterface); stdcall;
    procedure RemoveExtension(AInterface: IInterface); stdcall;
    procedure SetParent(AParent: IQServices); stdcall;
    function GetName: PWideChar; stdcall;
    function GetAttrs: IQParams; stdcall;
    function GetLastErrorMsg: PWideChar; stdcall;
    function GetLastErrorCode: Cardinal; stdcall;
    function GetId: TGuid; stdcall;
    function GetLoader: IQLoader; stdcall;
    function GetOriginObject: Pointer; stdcall;
    function IsInModule(AModule: THandle): Boolean; stdcall;
    property Parent: IQServices read GetParent write SetParent;
    property Name: PWideChar read GetName;
    property Attrs: IQParams read GetAttrs;
    property LastError: Cardinal read GetLastErrorCode;
    property LastErrorMsg: PWideChar read GetLastErrorMsg;
    property Loader: IQLoader read GetLoader;
    property Creator: IQService read GetInstanceCreator;
  end;

  // ��������б�
  IQServices = interface
    ['{7325DF17-BC83-4163-BB72-0AE0208352ED}']
    function GetItems(AIndex: Integer): IQService; stdcall;
    function GetCount: Integer; stdcall;
    function ByPath(APath: PWideChar): IQService; stdcall;
    function ById(const AId: TGuid; ADoGetInstance: Boolean = true)
      : IQService; stdcall;
    function Add(AItem: IQService): Integer; stdcall;
    function IndexOf(AItem: IQService): Integer; stdcall;
    procedure Delete(AIndex: Integer); stdcall;
    procedure Remove(AItem: IQService); stdcall;
    function MoveTo(AIndex, ANewIndex: Integer): Boolean; stdcall;
    procedure Clear; stdcall;
    function GetParent: IQServices; stdcall;
    function GetName: PWideChar; stdcall;
    function GetOwnerInstance: HINST; stdcall;
    property Name: PWideChar read GetName;
    property Parent: IQServices read GetParent;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: IQService read GetItems; default;
  end;

  // ֪ͨ��Ӧ�ӿ�
  IQNotify = interface
    ['{00C7F80F-44BF-4E60-AA58-5992B2B71754}']
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  end;

  TQSubscribeEnumCallback = procedure(ANotify: IQNotify; AParam: Int64;
    var AContinue: Boolean); stdcall;

  // ֪ͨ������
  IQNotifyManager = interface
    ['{037DCCD1-6877-4917-A315-120CD3E403F4}']
    function Subscribe(ANotifyId: Cardinal; AHandler: IQNotify)
      : Boolean; stdcall;
    procedure Unsubscribe(ANotifyId: Cardinal; AHandler: IQNotify); stdcall;
    function IdByName(const AName: PWideChar): Cardinal; stdcall;
    function NameOfId(const AId: Cardinal): PWideChar; stdcall;
    procedure Send(AId: Cardinal; AParams: IQParams); stdcall;
    procedure Post(AId: Cardinal; AParams: IQParams); stdcall;
    procedure Clear;
    function EnumSubscribe(ANotifyId: Cardinal;
      ACallback: TQSubscribeEnumCallback; AParam: Int64): Integer; stdcall;
    function GetCount: Integer; stdcall;
    function GetId(const AIndex: Integer): Cardinal; stdcall;
    function GetName(const AIndex: Integer): PWideChar; stdcall;
    property Count: Integer read GetCount;
    property Id[const AIndex: Integer]: Cardinal read GetId;
    property Name[const AIndex: Integer]: PWideChar read GetName;
  end;

  // �����ı���·�ɹ�����Ŀ���˽ӿڽ�Ϊ��ʾ���޸�ʹ��
  IQTextRouter = interface(IQService)
    ['{F3834278-4D2F-46D5-AA72-6EF016CE7F3A}']
    function GetSource: PWideChar; stdcall; // ����Դ
    function GetTarget: PWideChar; stdcall; // ����Ŀ��
    procedure SetRule(const ASource, ATarget: PWideChar); stdcall; // ����Ŀ���Դ
  end;

  // ���� ID ӳ��Ĺ�����Ŀ
  IQIdRouter = interface(IQService)
    ['{C2390553-ABE3-489A-8713-CB28A938C000}']
    function GetSource: TGuid; stdcall;
    function GetTarget: TGuid; stdcall;
    procedure SetRule(const ASource, ATarget: TGuid); stdcall;
  end;

  TQModuleState = (msUnknown, msLoading, msLoaded, msUnloading);
  TQLoaderState = (lsIdle, lsLoading, lsUnloading);

  // �������ӿڣ�����ʵ�ֻ����� TQBaseLoader
  IQLoader = interface(IQService)
    ['{3F576A14-D251-47C4-AB6E-0F89B849B71F}']
    function GetServiceSource(AService: IQService; ABuf: PWideChar;
      ALen: Integer): Integer; stdcall;
    procedure Start; stdcall;
    procedure Stop; stdcall;
    function LoadServices(const AFileName: PWideChar): THandle;
      stdcall; overload;
    function LoadServices(const AStream: IQStream): THandle; stdcall; overload;
    function UnloadServices(const AHandle: THandle; AWaitDone: Boolean = true)
      : Boolean; stdcall;
    function GetModuleCount: Integer; stdcall;
    function GetModuleName(AIndex: Integer): PWideChar; stdcall;
    function GetModules(AIndex: Integer): HMODULE; stdcall;
    function GetModuleState(AInstance: HINST): TQModuleState; stdcall;
    procedure SetLoadingModule(AInstance: HINST); stdcall;
    function GetLoadingFileName: PWideChar; stdcall;
    function GetLoadingModule: HINST; stdcall;
    function GetState: TQLoaderState; stdcall;
  end;

  // ��־�ӿڣ�һ���������ṩ��DelphiĬ��ʹ��QLog��װ
  IQLog = interface(IQService)
    ['{14F4C543-2D43-4AAD-BAFE-B25784BC917D}']
    procedure Post(ALevel: BYTE; AMsg: PWideChar); stdcall;
    procedure Flush; stdcall;
  end;

  // QWorker�ӿڷ�װ
  IQNotifyCallback = interface
    ['{8039F16A-0D0C-42C9-B891-454935371ACE}']
    procedure DoNotify(ASender: IInterface); stdcall;
  end;

  IQJobCallback = interface
    ['{886BE1F7-3365-4F81-9CEA-742EBD833584}']
    procedure DoJob(AParams: IQParams); stdcall;
  end;

  IQJobGroup = interface
    ['{061C27B2-1D09-42FA-8A80-B738E8CFA5F3}']
    procedure Cancel(AWaitRunningDone: Boolean = true); stdcall;
    procedure Prepare; stdcall;
    procedure Run(ATimeout: Cardinal = INFINITE); stdcall;
    function Insert(AIndex: Integer; AJob: IQJobCallback; AParams: IQParams;
      ARunInMainThread: Boolean): Boolean; stdcall;
    function Add(AJob: IQJobCallback; AParams: IQParams; AInMainThread: Boolean)
      : Boolean; stdcall;
    function Wait(ABlockMessage: Boolean; ATimeout: Cardinal = INFINITE)
      : TWaitResult; overload;
    function GetCount: Integer; stdcall;
    procedure SetAfterDone(AValue: IQNotifyCallback); stdcall;
    function GetAfterDone: IQNotifyCallback; stdcall;
    function GetByOrder: Boolean; stdcall;
    function GetFreeAfterDone: Boolean; stdcall;
    procedure SetFreeAfterDone(AValue: Boolean); stdcall;
    function GetRuns: Integer; stdcall;
    property Count: Integer read GetCount;
    property AfterDone: IQNotifyCallback read GetAfterDone write SetAfterDone;
    property ByOrder: Boolean read GetByOrder;
    property FreeAfterDone: Boolean read GetFreeAfterDone
      write SetFreeAfterDone;
    property Runs: Integer read GetRuns;
  end;

  IQWorkers = interface
    ['{94B6F5B4-1C16-448F-927C-DD8772DDAA78}']
    function Post(AJob: IQJobCallback; AParams: IQParams;
      ARunInMainThread: Boolean): Int64; stdcall;
    function Timer(AJob: IQJobCallback; AParams: IQParams;
      ARunInMainThread: Boolean): Int64; stdcall;
    function Delay(AJob: IQJobCallback; AParams: IQParams; ADelay: Int64;
      AInterval: Cardinal; ARunInMainThread: Boolean): Int64; stdcall;
    function At(AJob: IQJobCallback; AParams: IQParams; ATime: TDateTime;
      AInterval: Cardinal; ARunInMainThread: Boolean): Int64; stdcall;
    function Plan(AJob: IQJobCallback; AParams: IQParams; APlan: PWideChar;
      ARunInMainThread: Boolean): Int64; stdcall;
    procedure &For(AJob: IQJobCallback; AParams: IQParams;
      AStart, AStop: Integer; AMsgWait: Boolean); stdcall;
    procedure Clear(AHandle: THandle); stdcall;
    function CreateJobGroup(AByOrder: Boolean): IQJobGroup; stdcall;
    function SetWorkers(const AMinWorkers, AMaxWorkers: Integer); stdcall;
    procedure PeekCurrentWorkers(var ATotal, AIdle, ABusy: Integer); stdcall;
  end;

  TQServiceCallback = procedure(const AService: IQService); stdcall;

  // ��������������з�����ܹܼ�
  IQPluginsManager = interface(IQServices)
    ['{BDE6247B-87AD-4105-BDC9-1EA345A9E4B0}']
    function GetLoaders: IQServices; stdcall;
    function GetRouters: IQServices; stdcall;
    function GetServices: IQServices; stdcall;
    function ForcePath(APath: PWideChar): IQServices; stdcall;
    function GetActiveLoader: IQLoader; stdcall;
    procedure SetActiveLoader(ALoader: IQLoader); stdcall;
    procedure Start; stdcall;
    procedure ModuleUnloading(AInstance: HINST); stdcall;
    procedure AsynCall(AProc: TQAsynProcG; AParams: IQParams); stdcall;
    procedure ProcessQueuedCalls; stdcall;
    function Stop: Boolean; stdcall;
    function Replace(ANewManager: IQPluginsManager): Boolean; stdcall;
    function WaitService(const AService: PWideChar; ANotify: TQServiceCallback)
      : Boolean; overload; stdcall;
    function WaitService(const AId: TGuid; ANotify: TQServiceCallback): Boolean;
      overload; stdcall;
    procedure RemoveServiceWait(ANotify: TQServiceCallback); overload; stdcall;
    procedure RemoveServiceWait(const AService: PWideChar;
      ANotify: TQServiceCallback); overload; stdcall;
    procedure RemoveServiceWait(const AId: TGuid; ANotify: TQServiceCallback);
      overload; stdcall;
    procedure ServiceReady(AService: IQService); stdcall;
    property Services: IQServices read GetServices;
    property Routers: IQServices read GetRouters;
    property Loaders: IQServices read GetLoaders;
    property ActiveLoader: IQLoader read GetActiveLoader write SetActiveLoader;
  end;

  // �ṩ���������ͷ�װ֧��

  IQLocker = interface
    ['{5008B5D4-EE67-419D-80CB-E5C62FA95243}']
    procedure Lock; stdcall;
    procedure Unlock; stdcall;
  end;

implementation

end.
