# RecipeForFetch 
By Ahmed Irtija 
---
## Steps to Run the Code
1. Clone this repo to the latest version of Xcode.
2. Open the *ListView* file and change the variable titled `JSONUrl` to the corresponding URL for the JSON file. If not, keep the variable as is to query the provided URL.
3. Run the code on a simulator or your iPhone to view the app.

## Focus Areas
I emphasized on user experience by designing a seamless interface and optimizing for low latency. The important part of this app was how users interact with the app, as they are the core audience. While creating an intuitive and responsive UI, I also ensured the code remained clean and scalable, with enough comments to make its functionality easy to understand for other developers.

## Time Spent
I worked on this project for 4 hours however, most of the time were spent ensuring a beautiful design and adding features to improve the UI/UX. Approximately 1.5 hours were spent completing the main functionality, which I worked on first. The remaining 2.5 hours were dedicated to adding and improving features and designs.

## Trade-offs and Decisions
The main trade-off I had to make was writing lenghty code where it can get confusing when reading sometimes. This trade-off was due to the fact that the image caching needed to be done through custom methods. 

## Weakest Part of the Project
The weakest part of the project is the unit testing. For this, I only needed to check if it was reading the JSON correctly which I did through multiple test cases with malformed URLs and empty URLs. Since UI testing was not necessary and to save time, I did not include it.

## Additional Information
- Once the app has loaded, if there's an error, an error image will provide the details on that error.
- If not, there will be a list of recipes that includes its name, cuisine type, link to website, and a link to video, if available. 
- It has a refresh featucrore by slling up on the screen which also randomizes the recipes.
- It has a sorting feature which sorts by A-Z or Z-A or by the type of cuisine.
- If recipes have a link to the source of the recipes then it will have a link to it indicated by the blue colored name.
- If recipes have a cyan play button next to the name then pressing it will lead to the Youtube url of the recipe.
- You can scroll around to view all the recipes
