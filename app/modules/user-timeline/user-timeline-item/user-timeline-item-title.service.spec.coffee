describe "tgUserTimelineItemTitle", ->
    mySvc = null
    mockTranslate = null
    timeline = event = type = null

    _mockTranslate = () ->
        _provide (provide) ->
            mockTranslate = {
                instant: sinon.stub()
            }

            provide.value "$translate", mockTranslate

    _provide = (callback) ->
        module ($provide) ->
            callback($provide)
            return null

    _mocks = () ->
        _mockTranslate()

    _inject = ->
        inject (_tgUserTimelineItemTitle_) ->
            mySvc = _tgUserTimelineItemTitle_

    _setup = ->
        _mocks()
        _inject()

    beforeEach ->
        module "taigaUserTimeline"
        _setup()

    it "title with username", () ->
        timeline = {
            data: {
                user: {
                    username: 'xx',
                    name: 'oo'
                }
            }
        }

        event = {}

        type = {
            key: 'TITLE_USER_NAME',
            translate_params: ['username']
        }

        mockTranslate.instant
            .withArgs('COMMON.SEE_USER_PROFILE', {username: timeline.data.user.username})
            .returns('user-param')

        usernamelink = sinon.match ((value) ->
            return value.username == '<a tg-nav="user-profile:username=vm.activity.user.username" title="user-param">oo</a>'
         ), "usernamelink"

        mockTranslate.instant
            .withArgs('TITLE_USER_NAME', usernamelink)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "title with a field name", () ->
        timeline = {
            data: {
                values_diff: {
                    status: {}
                }
            }
        }

        event = {}

        type = {
            key: 'TITLE_FIELD',
            translate_params: ['field_name']
        }

        mockTranslate.instant
            .withArgs('COMMON.FIELDS.STATUS')
            .returns('field-params')

        fieldparam = sinon.match ((value) ->
            return value.field_name == 'field-params'
         ), "fieldparam"

        mockTranslate.instant
            .withArgs('TITLE_FIELD', fieldparam)
            .returns('title_ok')


        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "title with new value", () ->
        timeline = {
            data: {
                values_diff: {
                    status: ['old', 'new']
                }
            }
        }

        event = {}

        type = {
            key: 'NEW_VALUE',
            translate_params: ['new_value']
        }

        mockTranslate.instant
            .withArgs('NEW_VALUE', {new_value: 'new'})
            .returns('new_value_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("new_value_ok")

    it "title with project name", () ->
        timeline = {
            data: {
                project: {
                    name: "project_name"
                }
            }
        }

        event = {}

        type = {
            key: 'TITLE_PROJECT',
            translate_params: ['project_name']
        }

        projectparam = sinon.match ((value) ->
            return value.project_name == '<a tg-nav="project:project=vm.activity.project.slug" title="project_name">project_name</a>'
         ), "projectparam"

        mockTranslate.instant
            .withArgs('TITLE_PROJECT', projectparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "title with sprint name", () ->
        timeline = {
            data: {
                milestone: {
                    name: "milestone_name"
                }
            }
        }

        event = {}

        type = {
            key: 'TITLE_MILESTONE',
            translate_params: ['sprint_name']
        }

        milestoneparam = sinon.match ((value) ->
            return value.sprint_name == '<a tg-nav="project-taskboard:project=vm.activity.project.slug,sprint=vm.activity.sprint.slug" title="milestone_name">milestone_name</a>'
         ), "milestoneparam"

        mockTranslate.instant
            .withArgs('TITLE_MILESTONE', milestoneparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "title with object", () ->
        timeline = {
            data: {
                issue: {
                    ref: '123',
                    subject: 'subject'
                }
            }
        }

        event = {
            obj: 'issue',
        }

        type = {
            key: 'TITLE_OBJ',
            translate_params: ['obj_name']
        }

        objparam = sinon.match ((value) ->
            return value.obj_name == '<a tg-nav="project-issues-detail:project=vm.activity.project.slug,ref=vm.activity.obj.ref" title="#123 subject">#123 subject</a>'
         ), "objparam"

        mockTranslate.instant
            .withArgs('TITLE_OBJ', objparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "title obj wiki", () ->
        timeline = {
            data: {
                wikipage: {
                    slug: 'slug-wiki',
                }
            }
        }

        event = {
            obj: 'wikipage',
        }

        type = {
            key: 'TITLE_OBJ',
            translate_params: ['obj_name']
        }

        objparam = sinon.match ((value) ->
            return value.obj_name == '<a tg-nav="project-wiki-page:project=vm.activity.project.slug,slug=vm.activity.obj.slug" title="Slug wiki">Slug wiki</a>'
         ), "objparam"

        mockTranslate.instant
            .withArgs('TITLE_OBJ', objparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "title obj milestone", () ->
        timeline = {
            data: {
                milestone: {
                    name: 'milestone_name',
                }
            }
        }

        event = {
            obj: 'milestone',
        }

        type = {
            key: 'TITLE_OBJ',
            translate_params: ['obj_name']
        }

        objparam = sinon.match ((value) ->
            return value.obj_name == '<a tg-nav="project-taskboard:project=vm.activity.project.slug,sprint=vm.activity.obj.slug" title="milestone_name">milestone_name</a>'
         ), "objparam"

        mockTranslate.instant
            .withArgs('TITLE_OBJ', objparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "task title with us_name", () ->
        timeline = {
            data: {
                task: {
                    name: 'task_name',
                    userstory: {
                        ref: 2
                        subject: 'subject'
                    }
                }
            }
        }

        event = {
            obj: 'task',
        }

        type = {
            key: 'TITLE_OBJ',
            translate_params: ['us_name']
        }

        objparam = sinon.match ((value) ->
            return value.us_name == '<a tg-nav="project-userstories-detail:project=vm.activity.project.slug,ref=vm.activity.obj.userstory.ref" title="#2 subject">#2 subject</a>'
         ), "objparam"

        mockTranslate.instant
            .withArgs('TITLE_OBJ', objparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")

    it "task title with us_name", () ->
        timeline = {
            data: {
                task: {
                    name: 'task_name',
                    userstory: {
                        ref: 2
                        subject: 'subject'
                    }
                }
            }
        }

        event = {
            obj: 'task',
        }

        type = {
            key: 'TITLE_OBJ',
            translate_params: ['us_name']
        }

        objparam = sinon.match ((value) ->
            return value.us_name == '<a tg-nav="project-userstories-detail:project=vm.activity.project.slug,ref=vm.activity.obj.userstory.ref" title="#2 subject">#2 subject</a>'
         ), "objparam"

        mockTranslate.instant
            .withArgs('TITLE_OBJ', objparam)
            .returns('title_ok')

        title = mySvc.getTitle(timeline, event, type)

        expect(title).to.be.equal("title_ok")
