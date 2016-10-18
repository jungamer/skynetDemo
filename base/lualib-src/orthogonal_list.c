#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include "uthash.h"

struct ol_node {
    struct ol_node *next;
    uint32_t id;
    float position[2];
    float aoi_radis;
};

struct link_list {
    struct ol_node head;
    struct ol_node *tail;
};

struct node_map {
    uint32_t id;
    UT_hash_handle hh;
    struct ol_node *node;
};

struct ol {
    struct link_list row;
    struct link_list col;
    struct node_map *nodes;
};

static void *
map_init(struct node_map **nodes) {
    *nodes = NULL;
}

static void *
map_insert(struct node_map **nodes, struct ol_node *node) {
    struct node_map *temp_node = malloc(sizeof(*temp_node));
    temp_node->node = node;
    temp_node->id = node->id;
    HASH_ADD_INT((*nodes), id, temp_node);
}

static struct ol_node *
map_delete(struct node_map **nodes, uint32_t id) {
    struct node_map *result = NULL;
    HASH_FIND_INT((*nodes), &id, result);
    struct ol_node * ol_node = NULL;
    if(result) {
        ol_node = result->node;
        HASH_DEL(*nodes, result);
        free(result);
    }
    return ol_node;
}

static struct ol_node *
map_query(struct node_map **nodes, uint32_t id) {
    struct node_map *result = NULL;
    HASH_FIND_INT((*nodes), &id, result);
    if (result) {
        return result->node;
    }
}

static inline struct ol_node *
link_clear(struct link_list *list) {
    struct ol_node * ret = list->head.next;
    list->head.next = 0;
    list->tail = &(list->head);
    return ret;
}

static void
link(struct link_list *list,struct ol_node *node, uint8_t index) {
    struct ol_node *cur_node = list->head.next;
    struct ol_node *pre_node = NULL;
    while(cur_node) {
        if (cur_node->position[index] >= node->position[index]) {
            break;
        }
        pre_node = cur_node;
        cur_node = cur_node->next;
    }
    if(pre_node) {
        node->next = cur_node;
        pre_node->next = node;
    }
    else {
        node->next = list->head.next;
        list->head.next = node;
    }
}

static void
add_node(struct ol *OL, struct ol_node *node) {
    link(&OL->row, node, 0);
    link(&OL->col, node, 1);
    map_insert(&OL->nodes, node);
}

static void
ol_add(struct ol *OL, uint32_t id, float * position, float aoi_radis) {
    struct node_map *result = NULL;
    struct ol_node *node = map_query(&OL->nodes, id);
    if (!node) {
        struct ol_node *node = (struct ol_node *)malloc(sizeof(*node));
        node->id = id;
        node->position[0] = position[0];
        node->position[1] = position[1];
        node->aoi_radis = aoi_radis;
        add_node(OL, node);
    }
}

static void
ol_delete(struct ol *OL, uint32_t id) {
    struct ol_node *node = map_delete(&OL->nodes, id);
    if (node) {
        free(node);
    }
}

static void
ol_update(struct ol *OL, uint32_t id, float * position, float aoi_radis) {
}

static struct ol *
create_ol() {
	struct ol *ol_aoi =(struct ol *)malloc(sizeof(struct ol));
	memset(ol_aoi, 0, sizeof(*ol_aoi));
    link_clear(&ol_aoi->row);
    link_clear(&ol_aoi->col);
    map_init(&ol_aoi->nodes);
    return ol_aoi;
}
