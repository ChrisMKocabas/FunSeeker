//
//  UserProfileView.swift
//  MarsExplorer
//
//  Created by Muhammed Kocabas on 2023-03-02.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAnalyticsSwift
import FirebaseAuth

enum TransactionType {
  case email
  case password
  case blank
}


struct UserProfileView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss
  @State var presentingConfirmationDialog = false
  @State var transactionStatus = TransactionType.blank
  @State var showNewScreen: Bool = false

  private func deleteAccount() {
    Task {
      if await viewModel.deleteAccount() == true {
        dismiss()
      }
    }
  }

  private func updateEmail(){
    showNewScreen.toggle()
    transactionStatus = TransactionType.email
  }

  private func updatePassword(){
    showNewScreen.toggle()
    transactionStatus = TransactionType.password
  }

  private func signOut() {
    viewModel.signOut()
  }


  var body: some View {
    ZStack{
      Form {
        Section {
          VStack {
            HStack {
              Spacer()
              Image(systemName: "person.fill")
                .resizable()
                .frame(width: 100 , height: 100)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .clipped()
                .padding(4)
                .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
              Spacer()
            }
            Button(action: {}) {
              Text("edit")
            }
          }
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
        Section("Email") {
          Text(viewModel.displayName)
        }

        Section {
          Button( action: updatePassword) {
            HStack {
              Spacer()
              Text("Change Password")
              Spacer()
            }
          }
        }
        Section {
          Button( action: updateEmail) {
            HStack {
              Spacer()
              Text("Change Email")
              Spacer()
            }
          }
        }
        Section {
          Button(role: .cancel, action: signOut) {
            HStack {
              Spacer()
              Text("Sign out")
              Spacer()
            }
          }
        }
        Section {
          Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
            HStack {
              Spacer()
              Text("Delete Account")
              Spacer()
            }
          }
        }
      }
      ZStack {
        NewScreen(showNewScreen: $showNewScreen, transactionStatus: $transactionStatus)
          .padding(.top, 100)
          .opacity(showNewScreen ? 1 : 0)
          .animation(.spring(response:0.55, dampingFraction: 0.7,
                            blendDuration: 0), value: showNewScreen)
          .offset(y: showNewScreen ? 0 : UIScreen.main.bounds.height)
      }
    }
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.inline)
    .analyticsScreen(name: "\(Self.self)")
    .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                        isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
      Button("Delete Account", role: .destructive, action: deleteAccount)
      Button("Cancel", role: .cancel, action: { })
    }
  }
}

struct UserProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserProfileView()
        .environmentObject(AuthenticationViewModel())
    }
  }
}


struct NewScreen: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var showNewScreen: Bool
    @Binding var transactionStatus: TransactionType
    @State var email: String = ""
    @State var password: String = ""
    @State var newPassword: String = ""
    @State var verifyPassword:String = ""
    @State var systemMessage:String = ""

  private func updateEmail(){
    Task {
      systemMessage = await viewModel.updateEmail(email: email, password: password)
      email = ""
      password = ""
    }
  }

  private func updatePassword(){
    if newPassword == verifyPassword {
      Task {
        systemMessage = await viewModel.updatePassword(password: password, newPassword:newPassword)
        password = ""
        newPassword = ""
        verifyPassword = ""
      }
    } else {
      systemMessage = "Passwords fields do not match."
    }
  }

    var body: some View {
        ZStack(alignment: .topLeading) {
          Color(UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 0.95))
                .edgesIgnoringSafeArea(.all)

            Button(action: {
              //presentationMode.wrappedValue.dismiss()
              showNewScreen.toggle()
              transactionStatus = TransactionType.blank
              systemMessage = ""
              email = ""
              password = ""
              newPassword = ""
              verifyPassword = ""
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
                    .padding(20)
            })

          VStack{

            if(transactionStatus == TransactionType.email){
              Text("\(viewModel.user?.email ?? "Please login")")
                .frame(maxWidth: .infinity, alignment:.leading)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.vertical, 15)

              TextField("Please enter new \(String(describing: transactionStatus)): ", text: $email)
                .padding()
                .multilineTextAlignment(.leading)
                .background(Color.white)
                .cornerRadius(12)
              SecureField("Please enter password: ", text: $password)
                .padding()
                .multilineTextAlignment(.leading)
                .background(Color.white)
                .cornerRadius(12)

              Button(action: updateEmail){
                HStack {
                  Spacer()
                  Text("Update")
                  Spacer()
                }
              }.frame(maxWidth: .infinity,maxHeight: 60)
                .foregroundColor(Color.blue)
                .background(Color.white)
                .fontWeight(.semibold)
                .cornerRadius(12)
                .padding(.top,20)
              Spacer()

            } else {

              SecureField("Plese enter current password", text: $password)
                .frame(maxWidth: .infinity, alignment:.leading)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.vertical, 20)

              SecureField("Please enter new password: ", text: $newPassword)
                .padding()
                .multilineTextAlignment(.leading)
                .background(Color.white)
                .cornerRadius(12)
              SecureField("Verify new password: ", text: $verifyPassword)
                .padding()
                .multilineTextAlignment(.leading)
                .background(Color.white)
                .cornerRadius(12)
              Button(action: updatePassword){
                HStack {
                  Spacer()
                  Text("Update")
                  Spacer()
                }.frame(maxWidth: .infinity,maxHeight: 60)
                  .foregroundColor(Color.blue)
                  .background(Color.white)
                  .fontWeight(.semibold)
                  .cornerRadius(12)
                  .padding(.top,20)
                Spacer()
              }
            }
            Text("\(systemMessage)")
              .frame(maxWidth: .infinity, maxHeight: 80, alignment:.center)
              .padding(.vertical,20)
              .cornerRadius(12)



          }.padding(EdgeInsets(top: 80, leading: 10, bottom: 10, trailing: 10))

        }
    }
}
