feature "ToDos" do
  scenario "A user can sign in a create/edit a ToDo" do

    visit "/"

    click_link "Register"

    fill_in "Username", with: "hunta"
    fill_in "Password", with: "pazzword"

    click_button "Register"

    fill_in "Username", with: "hunta"
    fill_in "Password", with: "pazzword"

    click_button "Sign In"

    expect(page).to have_content "Welcome, hunta"

    fill_in "What do you need to do?", with: "Get a haircut"
    click_button "Add ToDo"

    expect(page).to have_content "ToDo added"

    within ".todos" do
      expect(page).to have_content "Get a haircut"
    end

    click_button "Edit ToDo"
    fill_in "Update Your ToDo", with: "Get a perm"
    click_button "Update ToDo"

      expect(page).to have_content "Get a perm"
      expect(page).to have_no_content "Get a haircut"
      expect(page).to have_content "ToDo updated"

    click_button "Complete"
    expect(page).to have_no_content "Get a perm"


  end
end
