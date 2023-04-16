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
  case updateEmail
  case updatePassword
  case blank
}


struct UserProfileView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss
  @State var presentingConfirmationDialog = false
  @State var email:String = ""
  @State var password: String = ""
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
//    transactionStatus = TransactionType.updateEmail
//    Task {
//      await viewModel.updateEmail(email: email)
//    }
    showNewScreen.toggle()
  }

  private func updatePassword(){
    transactionStatus = TransactionType.updatePassword
    Task {
      await viewModel.updatePassword(password: password)
    }
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
        NewScreen(showNewScreen: $showNewScreen)
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

    @Environment(\.presentationMode) var presentationMode
    @Binding var showNewScreen: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
          Color.white
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                //presentationMode.wrappedValue.dismiss()
                showNewScreen.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
                    .padding(20)
            })
        }
    }
}
