#include <string.h>
#include <stdio.h>
#include <stdlib.h>

//Doubly-linked list struct.
struct DLL {
	struct node *head;
};

//node struct
struct node {
	char *value;
	struct node *next;
    struct node *prev;
};

//node factory class.
struct node* makeNode(char *val){
	//Create our node pointer
	struct node* tmp = (struct node*) malloc(sizeof(struct node));
	//Rather than dereferencing tmp, 
	//we can use this convenient shorthand
	tmp->value = (char *) malloc(sizeof(char)*30);
	//Copy the value into the char array 
	strncpy( (*tmp).value, val, 29 );
    //29 IS THE MAX CHARACTER LIMIT
    
	//Set the next and prev pointers to NULL because it hasn't been
	//inserted into a list yet.
	tmp->next = NULL;
    tmp->prev = NULL;
	return tmp;
}

//Helper function to print a node
void printNode(struct node* n){
	printf("addy: %p\nvalue: %s\n",n,n->value);
}

//Insertion function: Inserts n2 AFTER n1 in the list.
int insertNodeAfter( struct node* n1, struct node* n2){
	n2->next = n1->next;
    n2->prev = n1;
	n1->next = n2;
}

//List factory class.
//Returns a list and sets the head pointer to null
//because there are no nodes in the list as of yet.
struct DLL* makeList(){
	struct DLL* dll = (struct DLL*) malloc(sizeof(struct DLL));
	struct node* h = NULL;
	dll->head = h;
	return dll;
}

//Finds the end of the list and appends n there.
struct SLL* appendToList(struct DLL* dll, struct node* n){
	//Find the end of the list.
	//And append...
	//There is nothing in the list. So make this the first item in the list...
	if( dll->head == NULL){
		dll->head = n;
        //If n is already part of a list, ie has a value for next and prev, the new list becomes a copy of n's list, except with n (no matter its position in the first list) the head.
        //Should I break its connection to previous?
        //Should head have a previous node?
	} else {
		struct node* curr = dll->head;
		while(curr->next != NULL){
			curr = curr->next;
		}
		curr->next = n;
	//	insertNodeAfter(curr,n);
	}
	return dll;
}

int main(){
	//Make a SLL (abbrev SLL for short)
	struct SLL* shopping = makeList(); 
	//Create a node, add the node to the list.
	struct node* n1 = makeNode("cabbage");
	shopping = appendToList(shopping,n1);	
	//Create a node, add the node to the list.
	struct node* n2 = makeNode("goat's milk");
	shopping = appendToList(shopping,n2);
	//Create a ndoe, add the node to the list
	struct node* n3 = makeNode("beets");
	shopping = appendToList(shopping,n3);
	//Print the current list
	printNode(shopping->head);
	printNode(shopping->head->next);
	printNode(shopping->head->next->next);
}
