#import "CDVCustomKeyboard.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CDVCustomKeyboard ()<UITextViewDelegate>

@property (nonatomic, readwrite, assign) BOOL keyboardIsVisible;
@property (nonatomic,strong)UITextView *hiddenTextView;
@property (nonatomic,strong)UIView *backGroundView;
@property (nonatomic,strong)UIButton *clearButton;

@end

@implementation CDVCustomKeyboard

// UITextView *hiddenTextView;
// UIView *backGroundView;

// - (UIView *)backGroundView{
//   if(_backGroundView==nill){
//     _backGroundView=[UIView new];
//   }
// }

- (void)pluginInitialize
{
  CGFloat viewWidth=kScreenWidth;
  CGFloat viewHeight=40;
  CGFloat paddingTopBottom=5;
  CGFloat paddingLeftRight=3;

  if(self.backGroundView == NULL){
    self.backGroundView = [UIView new];
    self.backGroundView.alpha = 0;
    self.backGroundView.backgroundColor = [UIColor lightGrayColor];
//    self.backGroundView.frame=CGRectMake(0,height,width,36);
    self.backGroundView.frame=CGRectMake(0,0,viewWidth,viewHeight);
    [self.viewController.view addSubview:self.backGroundView];
  }
    if (self.hiddenTextView == NULL) {

        self.hiddenTextView = [[UITextView alloc] init];
        UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        doneToolbar.barStyle = UIBarStyleDefault;
        doneToolbar.translucent = FALSE;
        doneToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)], nil];
        [doneToolbar sizeToFit];
        self.hiddenTextView.inputAccessoryView = doneToolbar;
        self.hiddenTextView.alpha = 0;
        self.hiddenTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.hiddenTextView.frame = CGRectMake(paddingLeftRight, paddingTopBottom, viewWidth-paddingLeftRight*2, viewHeight-paddingTopBottom*2);
        self.hiddenTextView.font = [UIFont fontWithName:@"Helvetica" size:17];
        // 设置文本框背景颜色
        self.hiddenTextView.backgroundColor = [UIColor whiteColor];
        //外框
        self.hiddenTextView.layer.borderColor = [UIColor grayColor].CGColor;
        self.hiddenTextView.layer.borderWidth = 1;
        self.hiddenTextView.layer.cornerRadius =5;
        self.hiddenTextView.keyboardType = UIKeyboardTypeDecimalPad;
        self.hiddenTextView.delegate = self;

        //边距
        self.hiddenTextView.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 35);
        [self.backGroundView addSubview:self.hiddenTextView];
        
        //clear button
        int kClearButtonWidth = 30;
        int kClearButtonHeight = kClearButtonWidth;
        
        //add the clear button
        self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.clearButton setImage:[UIImage imageNamed:@"UITextFieldClearButton.png"] forState:UIControlStateNormal];
        [self.clearButton setImage:[UIImage imageNamed:@"UITextFieldClearButtonPressed.png"] forState:UIControlStateHighlighted];
        self.clearButton.alpha = 0;
        self.clearButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.clearButton.frame = CGRectMake(0, 0, kClearButtonWidth, kClearButtonHeight);
        self.clearButton.center = CGPointMake(kScreenWidth - kClearButtonWidth , kClearButtonHeight/2);
        self.clearButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

        
        [self.clearButton addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.hiddenTextView addSubview:self.clearButton];
    }
//     // 增加监听，当键盘将要出现或改变时收出消息
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
//     // 增加监听，当键盘将要退出时收出消息
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
     // 增加监听，当键盘将要变化时收出消息
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:)name:UIKeyboardWillChangeFrameNotification object:nil];
    // 增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
    // 增加监听，当键盘退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification
//                                                   object:nil];
    // // 输入法切换
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputModeDidChange:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];

}

//- (void) inputModeDidChange:(NSNotification*) notification {
//    // NSLog(@"inputModeDidChange");
//    //currentInputMode is deprecated first in iOS7，因为它一次仅能输出一种（例如 en－US）
//     NSLog(@"[UITextInputMode currentInputMode] %@", [UITextInputMode currentInputMode].primaryLanguage);
//    for (UITextInputMode *mode in [UITextInputMode activeInputModes]) {
//        // 会输出 en－US、emoji 等
//        NSLog(@"mode.primaryLanguage %@", mode.primaryLanguage);
//    }
//}

- (void)clearTextView:(id)sender{
    self.hiddenTextView.text = @"";
    self.clearButton.alpha = 0;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: self.hiddenTextView.text];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult  callbackId:self.callbackId];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    if([text isEqualToString:@""]){
        self.clearButton.alpha = 0;
    }else{
        self.clearButton.alpha = 1;
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult  callbackId:self.callbackId];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    [self displayInputView:NO];
    NSString *text = textView.text;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:text];
    [self.commandDelegate sendPluginResult:pluginResult  callbackId:self.callbackId];
}

// 当键盘出现或改变时调用
// - (void)keyboardWillChange:(NSNotification *)aNotification{
    
//    // 获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect resultFrame;
//        resultFrame =CGRectMake(0,ScreenHeight-height-36,ScreenWidth,36);
//        self.backGroundView.frame=resultFrame;
//    }];
    
// }

//// 当键盘出现或改变时调用
// - (void)keyboardDidShow:(NSNotification *)aNotification{
//    self.hiddenTextView.secureTextEntry = NO;
//}
//// 当键盘出现或改变时调用
// - (void)keyboardDidHide:(NSNotification *)aNotification{
//   self.hiddenTextView.secureTextEntry = YES;
//}

// // 当键盘出现或改变时调用
//  - (void)keyboardWillShow:(NSNotification *)aNotification
// {
//     // 获取键盘的高度
//      NSDictionary *userInfo = [aNotification userInfo];
//     NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//     CGRect keyboardRect = [aValue CGRectValue];
//     int height = keyboardRect.size.height;
//     if (self.textView.text.length == 0) {
//
//         self.backGroundView.frame = CGRectMake(0, kScreenheight-height-49, kScreenwidth, 49);
//     }else{
//         CGRect rect = CGRectMake(0, kScreenheight - self.backGroundView.frame.size.height-height, kScreenwidth, self.backGroundView.frame.size.height);
//         self.backGroundView.frame = rect;
//     }
// }

 // 当键退出时调用
//  - (void)keyboardWillHide:(NSNotification *)aNotification
// {
//     [self displayInputView:NO];
//
//     if (self.textView.text.length == 0) {
//         self.backGroundView.frame = CGRectMake(0, 0, kScreenwidth, 49);
//         self.frame = CGRectMake(0, kScreenheight-49, kScreenwidth, 49);
//     }else{
//         CGRect rect = CGRectMake(0, 0, kScreenwidth, self.backGroundView.frame.size.height);
//         self.backGroundView.frame = rect;
//         self.frame = CGRectMake(0, kScreenheight - rect.size.height, kScreenwidth, self.backGroundView.frame.size.height);
//     }
// }

- (void)open:(CDVInvokedUrlCommand*)command
{
    [self displayInputView:YES];
    self.callbackId = command.callbackId;
    NSString *startedValue = [command argumentAtIndex:0];
    NSInteger keyBoardTypeInt = [[command argumentAtIndex:1] integerValue];

    switch (keyBoardTypeInt) {
        case 1:
            self.keyboardType =  UIKeyboardTypeDefault;                // Default type for the current input method.
            break;
        case 2:
            self.keyboardType =  UIKeyboardTypeASCIICapable;                // Default type for the current input method.
            break;
        case 3:
            self.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;                // Default type for the current input method.
            break;
        case 4:
            self.keyboardType =  UIKeyboardTypeURL;                // Default type for the current input method.
            break;
        case 5:
            self.keyboardType =  UIKeyboardTypeNumberPad;                // Default type for the current input method.
            break;
        case 6:
            self.keyboardType =  UIKeyboardTypePhonePad;                // Default type for the current input method.
            break;
        case 7:
            self.keyboardType =  UIKeyboardTypeNamePhonePad;                // Default type for the current input method.
            break;
        case 8:
            self.keyboardType =  UIKeyboardTypeEmailAddress;                // Default type for the current input method.
            break;
        case 9:
            self.keyboardType =  UIKeyboardTypeDecimalPad;                // Default type for the current input method.
            break;
        case 10:
            self.keyboardType =  UIKeyboardTypeTwitter;                // Default type for the current input method.
            break;
        case 11:
            self.keyboardType =  UIKeyboardTypeWebSearch;                // Default type for the current input method.
            break;
        case 12:
            self.keyboardType =  UIKeyboardTypeAlphabet;
            break;
        case 13:
            self.hiddenTextView.secureTextEntry = YES;
            break;
        default:
            self.keyboardType =  keyBoardTypeInt;
            break;
    }
    self.hiddenTextView.keyboardType = self.keyboardType;
    self.hiddenTextView.text = startedValue;
    [self.hiddenTextView becomeFirstResponder];
}

- (void)close:(CDVInvokedUrlCommand*)command
{
    [self.webView becomeFirstResponder];
    [self.hiddenTextView resignFirstResponder];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]  callbackId:command.callbackId];
}

- (void)change:(CDVInvokedUrlCommand*)command
{
    NSString *value = [command argumentAtIndex:0];
    self.hiddenTextView.text = value;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (BOOL)textView :(UITextView *)textView shouldChangeTextInRange :(NSRange)range replacementText :( NSString *)text{
    // need to escape these to be able to pass to the webview
  if ([text isEqualToString :@"\n"]) {
      // send event to JS
      // [self.commandDelegate sendPluginResult :P luginResult callbackId:callbackId];
    [self.hiddenTextView resignFirstResponder];
    return NO;
    // ignore the 'tab' character
  } else if ([text isEqualToString :@"\t"]) {
    [self.hiddenTextView resignFirstResponder];
    return NO;
  }
  return YES;
};

-(void)displayInputView:(BOOL)display
{
    if(display){
      self.hiddenTextView.alpha=1;
      self.backGroundView.alpha=1;
    }else{
      self.hiddenTextView.alpha=0;
      self.backGroundView.alpha=0;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.hiddenTextView = textView;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.hiddenTextView resignFirstResponder];
}

@end
