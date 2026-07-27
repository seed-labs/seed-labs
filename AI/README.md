# AI-generated Labs

We are now using AI to generate new labs. We have summarized the design principles in `seed-lab-design-principles.md`. The new labs should be put inside the `new-labs` folder: creating one folder for each new lab. We will manually revise and test each lab. After a lab becomes ready, we will move it out of this folder, place it in the corresponding category folder, and publish it on the SEED website. 


## Create lab description

Here is the prompt that we use to generate lab description:

```
Please use the principles in `AI/seed-lab-design-principles.md` to develop a new lab for me. Please follow the `AI/new-labs/README.md` file regarding how to organize the new labs.  The objective of the new lab is ... 
```

For example, when we ask the AI to develop a copy-fail lab, we provide the CVE to the AI.


## Create instructor manual

Here is the prompt for generating the instructor manual:

```
I want to create an instructor manual for this lab, so instructors can follow this manual to finish the lab. This manual is like an answer, showing the instructors step-by-step instructions. This manual is not meant for students. Please also put the manual in the same folder. The manual should not be committed to github.
```
